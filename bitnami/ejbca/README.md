<!--- app-name: EJBCA -->

# EJBCA packaged by Bitnami

EJBCA is an enterprise class PKI Certificate Authority software, built using Java (JEE) technology.

[Overview of EJBCA](http://www.ejbca.org)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.
                           
## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/ejbca
```

## Introduction

This chart bootstraps a [EJBCA](https://www.ejbca.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages [Bitnami MariaDB](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) as the required databases for the EJBCA application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release bitnami/ejbca
```

The command deploys EJBCA on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                     | Description                                                                             | Value          |
| ------------------------ | --------------------------------------------------------------------------------------- | -------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`           |
| `nameOverride`           | String to partially override ebjca.fullname template (will maintain the release name)   | `""`           |
| `fullnameOverride`       | String to fully override ebjca.fullname template                                        | `""`           |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`           |
| `commonLabels`           | Add labels to all the deployed resources                                                | `{}`           |
| `commonAnnotations`      | Annotations to be added to all deployed resources                                       | `{}`           |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`           |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`        |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`    |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]` |


### EJBCA parameters

| Name                                    | Description                                                                               | Value                    |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | ------------------------ |
| `image.registry`                        | EJBCA image registry                                                                      | `docker.io`              |
| `image.repository`                      | EJBCA image name                                                                          | `bitnami/ejbca`          |
| `image.tag`                             | EJBCA image tag                                                                           | `7.4.3-2-debian-10-r146` |
| `image.pullPolicy`                      | EJBCA image pull policy                                                                   | `IfNotPresent`           |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                                          | `[]`                     |
| `image.debug`                           | Enable image debug mode                                                                   | `false`                  |
| `replicaCount`                          | Number of EJBCA replicas to deploy                                                        | `1`                      |
| `extraVolumeMounts`                     | Additional volume mounts (used along with `extraVolumes`)                                 | `[]`                     |
| `extraVolumes`                          | Array of extra volumes to be added deployment. Requires setting `extraVolumeMounts`       | `[]`                     |
| `podAnnotations`                        | Additional pod annotations                                                                | `{}`                     |
| `podLabels`                             | Additional pod labels                                                                     | `{}`                     |
| `podSecurityContext.enabled`            | Enable security context for EJBCA container                                               | `true`                   |
| `podSecurityContext.fsGroup`            | Group ID for the volumes of the pod                                                       | `1001`                   |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                     |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                   |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                     |
| `nodeAffinityPreset.key`                | Node label key to match Ignored if `affinity` is set.                                     | `""`                     |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                 | `[]`                     |
| `affinity`                              | Affinity for pod assignment                                                               | `{}`                     |
| `nodeSelector`                          | Node labels for pod assignment                                                            | `{}`                     |
| `tolerations`                           | Tolerations for pod assignment                                                            | `[]`                     |
| `updateStrategy.type`                   | EJBCA deployment strategy type.                                                           | `RollingUpdate`          |
| `persistence.enabled`                   | Whether to enable persistence based on Persistent Volume Claims                           | `true`                   |
| `persistence.accessModes`               | Persistent Volume access modes                                                            | `[]`                     |
| `persistence.size`                      | Size of the PVC to request                                                                | `2Gi`                    |
| `persistence.storageClass`              | PVC Storage Class                                                                         | `""`                     |
| `persistence.existingClaim`             | Name of an existing PVC to reuse                                                          | `""`                     |
| `persistence.annotations`               | Persistent Volume Claim annotations                                                       | `{}`                     |
| `sidecars`                              | Attach additional sidecar containers to the pod                                           | `[]`                     |
| `initContainers`                        | Additional init containers to add to the pods                                             | `[]`                     |
| `hostAliases`                           | Add deployment host aliases                                                               | `[]`                     |
| `priorityClassName`                     | EJBCA pods' priorityClassName                                                             | `""`                     |
| `schedulerName`                         | Name of the k8s scheduler (other than default)                                            | `""`                     |
| `topologySpreadConstraints`             | Topology Spread Constraints for pod assignment                                            | `[]`                     |
| `ejbcaAdminUsername`                    | EJBCA administrator username                                                              | `bitnami`                |
| `ejbcaAdminPassword`                    | Password for the administrator account                                                    | `""`                     |
| `existingSecret`                        | Alternatively, you can provide the name of an existing secret containing                  | `""`                     |
| `ejbcaJavaOpts`                         | Options used to launch the WildFly server                                                 | `""`                     |
| `ejbcaCA.name`                          | Name of the CA EJBCA will instantiate by default                                          | `ManagementCA`           |
| `ejbcaCA.baseDN`                        | Base DomainName of the CA EJBCA will instantiate by default                               | `""`                     |
| `ejbcaKeystoreExistingSecret`           | Name of an existing Secret containing a Keystore object                                   | `""`                     |
| `extraEnvVars`                          | Array with extra environment variables to add to EJBCA nodes                              | `[]`                     |
| `extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for EJBCA nodes                      | `""`                     |
| `extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for EJBCA nodes                         | `""`                     |
| `command`                               | Custom command to override image cmd                                                      | `[]`                     |
| `args`                                  | Custom args for the custom command                                                        | `[]`                     |
| `lifecycleHooks`                        | for the EJBCA container(s) to automate configuration before or after startup              | `{}`                     |
| `resources.limits`                      | The resources limits for the container                                                    | `{}`                     |
| `resources.requests`                    | The requested resources for the container                                                 | `{}`                     |
| `containerSecurityContext.enabled`      | Enabled EJBCA containers' Security Context                                                | `true`                   |
| `containerSecurityContext.runAsUser`    | Set EJBCA containers' Security Context runAsUser                                          | `1001`                   |
| `containerSecurityContext.runAsNonRoot` | Set EJBCA container's Security Context runAsNonRoot                                       | `true`                   |
| `startupProbe.enabled`                  | Enable/disable startupProbe                                                               | `false`                  |
| `startupProbe.initialDelaySeconds`      | Delay before startup probe is initiated                                                   | `500`                    |
| `startupProbe.periodSeconds`            | How often to perform the probe                                                            | `10`                     |
| `startupProbe.timeoutSeconds`           | When the probe times out                                                                  | `5`                      |
| `startupProbe.failureThreshold`         | Minimum consecutive failures for the probe                                                | `6`                      |
| `startupProbe.successThreshold`         | Minimum consecutive successes for the probe                                               | `1`                      |
| `livenessProbe.enabled`                 | Enable/disable livenessProbe                                                              | `true`                   |
| `livenessProbe.initialDelaySeconds`     | Delay before liveness probe is initiated                                                  | `500`                    |
| `livenessProbe.periodSeconds`           | How often to perform the probe                                                            | `10`                     |
| `livenessProbe.timeoutSeconds`          | When the probe times out                                                                  | `5`                      |
| `livenessProbe.failureThreshold`        | Minimum consecutive failures for the probe                                                | `6`                      |
| `livenessProbe.successThreshold`        | Minimum consecutive successes for the probe                                               | `1`                      |
| `readinessProbe.enabled`                | Enable/disable readinessProbe                                                             | `true`                   |
| `readinessProbe.initialDelaySeconds`    | Delay before readiness probe is initiated                                                 | `500`                    |
| `readinessProbe.periodSeconds`          | How often to perform the probe                                                            | `10`                     |
| `readinessProbe.timeoutSeconds`         | When the probe times out                                                                  | `5`                      |
| `readinessProbe.failureThreshold`       | Minimum consecutive failures for the probe                                                | `6`                      |
| `readinessProbe.successThreshold`       | Minimum consecutive successes for the probe                                               | `1`                      |
| `customStartupProbe`                    | Custom startup probe to execute (when the main one is disabled)                           | `{}`                     |
| `customLivenessProbe`                   | Custom liveness probe to execute (when the main one is disabled)                          | `{}`                     |
| `customReadinessProbe`                  | Custom readiness probe to execute (when the main one is disabled)                         | `{}`                     |
| `containerPorts`                        | EJBCA Container ports to open                                                             | `{}`                     |


### Service parameters

| Name                               | Description                                                                   | Value          |
| ---------------------------------- | ----------------------------------------------------------------------------- | -------------- |
| `service.type`                     | Kubernetes Service type                                                       | `LoadBalancer` |
| `service.ports.http`               | Service HTTP port                                                             | `8080`         |
| `service.ports.https`              | Service HTTPS port                                                            | `8443`         |
| `service.advertisedHttpsPort`      | Port number used in the rendered URLs for the admistrator login.              | `443`          |
| `service.httpsTargetPort`          | Service Target HTTPS port                                                     | `https`        |
| `service.nodePorts`                | Node Ports to expose                                                          | `{}`           |
| `service.clusterIP`                | EJBCA service Cluster IP                                                      | `""`           |
| `service.loadBalancerIP`           | EJBCA service Load Balancer IP                                                | `""`           |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                          | `Cluster`      |
| `service.annotations`              | Service annotations                                                           | `{}`           |
| `service.loadBalancerSourceRanges` | Limits which cidr blocks can connect to service's load balancer               | `[]`           |
| `service.extraPorts`               | Extra ports to expose in the service (normally used with the `sidecar` value) | `[]`           |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"          | `None`         |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                   | `{}`           |


### Ingress parameters

| Name                       | Description                                                                                                                      | Value                    |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`          | Enable ingress controller resource                                                                                               | `false`                  |
| `ingress.pathType`         | Ingress Path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`       | Override API Version (automatically detected if not set)                                                                         | `""`                     |
| `ingress.hostname`         | Default host for the ingress resource                                                                                            | `ejbca.local`            |
| `ingress.path`             | The Path to EJBCA. You may need to set this to '/*' in order to use this                                                         | `/`                      |
| `ingress.annotations`      | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`              | Enable TLS configuration for the hostname defined at ingress.hostname parameter                                                  | `false`                  |
| `ingress.extraHosts`       | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`       | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`         | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`          | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.ingressClassName` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.extraRules`       | Additional rules to be covered with this ingress record                                                                          | `[]`                     |


### Database parameters

| Name                                        | Description                                                                                | Value           |
| ------------------------------------------- | ------------------------------------------------------------------------------------------ | --------------- |
| `mariadb.enabled`                           | Whether to deploy a mariadb server to satisfy the applications database requirements.      | `true`          |
| `mariadb.architecture`                      | MariaDB architecture (`standalone` or `replication`)                                       | `standalone`    |
| `mariadb.auth.rootPassword`                 | Password for the MariaDB `root` user                                                       | `""`            |
| `mariadb.auth.database`                     | Database name to create                                                                    | `bitnami_ejbca` |
| `mariadb.auth.username`                     | Database user to create                                                                    | `bn_ejbca`      |
| `mariadb.auth.password`                     | Password for the database                                                                  | `""`            |
| `mariadb.primary.persistence.enabled`       | Enable database persistence using PVC                                                      | `true`          |
| `mariadb.primary.persistence.storageClass`  | MariaDB primary persistent volume storage Class                                            | `""`            |
| `mariadb.primary.persistence.accessMode`    | Persistent Volume access mode                                                              | `ReadWriteOnce` |
| `mariadb.primary.persistence.size`          | Database Persistent Volume Size                                                            | `8Gi`           |
| `mariadb.primary.persistence.hostPath`      | Set path in case you want to use local host path volumes (not recommended in production)   | `""`            |
| `mariadb.primary.persistence.existingClaim` | Name of an existing `PersistentVolumeClaim` for MariaDB primary replicas                   | `""`            |
| `externalDatabase.host`                     | Host of the external database                                                              | `localhost`     |
| `externalDatabase.user`                     | non-root Username for EJBCA Database                                                       | `bn_ejbca`      |
| `externalDatabase.password`                 | Password for the above username                                                            | `""`            |
| `externalDatabase.existingSecret`           | Name of an existing secret resource containing the DB password in a 'mariadb-password' key | `""`            |
| `externalDatabase.database`                 | Name of the existing database                                                              | `bitnami_ejbca` |
| `externalDatabase.port`                     | Database port number                                                                       | `3306`          |


### NetworkPolicy parameters

| Name                                                          | Description                                                                                                               | Value   |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled`                                       | Enable network policies                                                                                                   | `false` |
| `networkPolicy.ingress.enabled`                               | Enable network policy for Ingress Proxies                                                                                 | `false` |
| `networkPolicy.ingress.namespaceSelector`                     | Ingress Proxy namespace selector labels. These labels will be used to identify the Ingress Proxy's namespace.             | `{}`    |
| `networkPolicy.ingress.podSelector`                           | Ingress Proxy pods selector labels. These labels will be used to identify the Ingress Proxy pods.                         | `{}`    |
| `networkPolicy.ingressRules.backendOnlyAccessibleByFrontend`  | Enable ingress rule that makes the backend (mariadb) only accessible by EJBCA's pods.                                     | `false` |
| `networkPolicy.ingressRules.customBackendSelector`            | Backend selector labels. These labels will be used to identify the backend pods.                                          | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.enabled`           | Enable ingress rule that makes EJBCA only accessible from a particular origin                                             | `false` |
| `networkPolicy.ingressRules.accessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to access EJBCA. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.podSelector`       | Pods selector label that is allowed to access EJBCA. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.customRules`                      | Custom network policy ingress rule                                                                                        | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`         | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                            | `false` |
| `networkPolicy.egressRules.customRules`                       | Custom network policy rule                                                                                                | `{}`    |


The above parameters map to the env variables defined in [bitnami/ejbca](https://github.com/bitnami/containers/tree/main/bitnami/ejbca). For more information please refer to the [bitnami/ejbca](https://github.com/bitnami/containers/tree/main/bitnami/ejbca) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set ejbcaAdminUsername=admin,ejbcaAdminPassword=password,mariadb.auth.password=secretpassword \
    bitnami/discourse
```

The above command sets the EJBCA administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `bn_ejbca` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml bitnami/ejbca
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling vs Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Set up replication

By default, this chart only deploys a single pod running EJBCA. To increase the number of replicas, follow the steps below:

1. Create a conventional release with only one replica. This will be scaled later.
2. Wait for the release to complete and for EJBCA to be running. Verify access to the main page of the application.
3. Perform an upgrade specifying the number of replicas and the credentials that were previously used. Set the parameters `replicaCount`, `ejbcaAdminPassword` and `mariadb.auth.password` accordingly.

For example, for a release using `secretPassword` and `dbPassword` to scale up to a total of `2` replicas, the aforementioned parameters should hold these values `replicaCount=2`, `ejbcaAdminPassword=secretPassword`, `mariadb.auth.password=dbPassword`.

> **Tip**: You can modify the file [values.yaml](values.yaml)

### Configure Sidecars and Init Containers

If additional containers are needed in the same pod as EJBCA (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. Similarly, you can add extra init containers using the `initContainers` parameter.

[Learn more about configuring and using sidecar and init containers](https://docs.bitnami.com/kubernetes/apps/ejbca/configuration/configure-sidecar-init-containers/).

### Use an external database

Sometimes, you may want to have EJBCA connect to an external database rather than a database within your cluster - for example, when using a managed database service, or when running a single database server for all your applications. To do this, set the `mariadb.enabled` parameter to `false` and specify the credentials for the external database using the `externalDatabase.*` parameters.

Refer to the [chart documentation on using an external database](https://docs.bitnami.com/kubernetes/apps/ejbca/configuration/use-external-database) for more details and an example.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the `affinity` parameter. Find more information about Pod affinity in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Use a different EJBCA version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter. Refer to the [chart documentation for more information on these parameters and how to use them with images from a private registry](https://docs.bitnami.com/kubernetes/apps/ejbca/configuration/change-image-version/).

## Persistence

The [Bitnami EJBCA](https://github.com/bitnami/containers/tree/main/bitnami/discourse) image stores the EJBCA data and configurations at the `/bitnami` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube. See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 6.0.0

The MariaDB subchart has been updated to the latest version (now it uses 10.6). No major issues are expected during the upgrade.

### To 5.0.0

This major release renames several values in this chart and adds missing features, in order to be inline with the rest of assets in the Bitnami charts repository.

Affected values:

- `service.port` was deprecated, we recommend using`service.ports.http` instead.
- `service.httpsPort` was deprecated, we recommend using`service.port.https` instead.
- `extraEnv` renamed as `extraEnvVars`
- `persistence.accessMode` has been deprecated, we recommend using `persistence.accessModes` instead.

Additionally, updates the MariaDB subchart to it newest major, 10.0.0, which contains similar changes.

### To 2.0.0

[On November 13, 2020, Helm v2 support formally ended](https://github.com/helm/charts#status-of-the-project). This major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

[Learn more about this change and related upgrade considerations](https://docs.bitnami.com/kubernetes/apps/ejbca/administration/upgrade-helm3/).

### To 1.0.0

MariaDB dependency version was bumped to a new major version that introduces several incompatilibites. Therefore, backwards compatibility is not guaranteed unless an external database is used. Check [MariaDB Upgrading Notes](https://github.com/bitnami/charts/tree/master/bitnami/mariadb#to-800) for more information.

To upgrade to `1.0.0`, you have two alternatives:

- Install a new EJBCA chart, and migrate your EJBCA following [the official documentation](https://doc.primekey.com/ejbca/ejbca-operations/ejbca-operations-guide/ca-operations-guide/ejbca-maintenance/backup-and-restore).
- Reuse the PVC used to hold the MariaDB data on your previous release. To do so, follow the instructions below (the following example assumes that the release name is `ejbca`):

> NOTE: Please, create a backup of your database before running any of those actions. The steps below would be only valid if your application (e.g. any plugins or custom code) is compatible with MariaDB 10.5.x

Obtain the credentials and the name of the PVC used to hold the MariaDB data on your current release:

```console
export EJBCA_ADMIN_PASSWORD=$(kubectl get secret --namespace default ejbca -o jsonpath="{.data.ejbca-admin-password}" | base64 -d)
export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default ejbca-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export MARIADB_PASSWORD=$(kubectl get secret --namespace default ejbca-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)
export MARIADB_PVC=$(kubectl get pvc -l app=mariadb,component=master,release=ejbca -o jsonpath="{.items[0].metadata.name}")
```

Upgrade your release (maintaining the version) disabling MariaDB and scaling EJBCA replicas to 0:

```console
$ helm upgrade ejbca bitnami/ejbca --set ejbcaAdminPassword=$EJBCA_ADMIN_PASSWORD --set replicaCount=0 --set mariadb.enabled=false --version 0.4.0
```

Finally, upgrade you release to 1.0.0 reusing the existing PVC, and enabling back MariaDB:

```console
$ helm upgrade ejbca bitnami/ejbca --set mariadb.primary.persistence.existingClaim=$MARIADB_PVC --set mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD --set mariadb.auth.password=$MARIADB_PASSWORD --set ejbcaAdminPassword=$EJBCA_ADMIN_PASSWORD
```

You should see the lines below in MariaDB container logs:

```console
$ kubectl logs $(kubectl get pods -l app.kubernetes.io/instance=ejbca,app.kubernetes.io/name=mariadb,app.kubernetes.io/component=primary -o jsonpath="{.items[0].metadata.name}")
...
mariadb 12:13:24.98 INFO  ==> Using persisted data
mariadb 12:13:25.01 INFO  ==> Running mysql_upgrade
...
```

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