<!--- app-name: cert-manager -->

# cert-manager packaged by Bitnami

cert-manager is a Kubernetes add-on to automate the management and issuance of TLS certificates from various issuing sources.

[Overview of cert-manager](https://github.com/jetstack/cert-manager)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/cert-manager
```

Looking to use cert-manager in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Introduction

Bitnami charts for Helm are carefully engineered, actively maintained and are the quickest and easiest way to deploy containers on a Kubernetes cluster that are ready to handle production workloads.

This chart bootstraps a [cert-manager](https://cert-manager.io/) Deployment in a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/cert-manager
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcePreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod as the cert-manager app (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

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

### Generate TLS certificates using Self Signed Issuers

Cert Manager supports issuing certificates through different Issuers. For instance, you can use a Self Signed Issuer to issue the certificates.

The Self Signed issuer doesn't represent a certificate authority as such, but instead denotes that certificates will "sign themselves" using a given private key.

> NOTE: Find the list of available Issuers in the [Cert Manager official documentation](https://cert-manager.io/docs/configuration/#supported-issuer-types).

To configure Cert Manager, create an Issuer object. The structure of this object differs depending on the Issuer type. Self Signed issuer are really easy to configure.

To create a self signed issuer to generate a self signed certificate, declare an Issuer, a ClusterIssuer and a Certificate, as shown below:

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-ca
  namespace: sandbox
spec:
  ca:
    secretName: letsencrypt-ca
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: letsencrypt-ca
  namespace: sandbox
spec:
  isCA: true
  commonName: osm-system
  secretName: letsencrypt-ca
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
    group: cert-manager.io
```

Next, use the ClusterIssuer to generate certificates for the applications in your Kubernetes cluster. [Learn how to secure your Ingress resources](#secure-ingress-resources-with-cert-manager).

After the Ingress resource is ready, Cert Manager will create a secret. This secret contains the generated TLS certificate. This can be checked as shown below:

```text
$ kubectl get secret --namespace=sandbox
NAME                  TYPE                                  DATA   AGE
letsencrypt-ca        kubernetes.io/tls                     3      Xs
```

### Generate TLS certificates using ACME Issuers

Cert Manager supports issuing certificates through different Issuers. For instance, you can use a public ACME (Automated Certificate Management Environment) server to issue the certificates.

> NOTE: Find the list of available Issuers in the [Cert Manager official documentation](https://cert-manager.io/docs/configuration/#supported-issuer-types).

To configure Cert Manager, create an Issuer object. The structure of this object differs depending on the Issuer type. For ACME, it is necessary to include the information for a single account registered in the ACME Certificate Authority server.

Once Cert Manager is configured to use ACME, it will verify that you are the owner of the domains for which certificates are being requested. Cert Manager uses two different challenges to verify that you are the owner of your domain: HTTP01 or DNS01. [Learn more about ACME challenges](https://cert-manager.io/docs/concepts/acme-orders-challenges/#challenge-scheduling).

> NOTE: Learn more about the process to solve challenges in the [official documentation](https://cert-manager.io/docs/configuration/acme/#solving-challenges).

To create a ACME issuer for use with Let's Encrypt, declare an Issuer as shown below:

```yaml
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    # Replace the EMAIL-ADDRESS placeholder with the correct email account
    email: EMAIL-ADDRESS
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx
```

Next, use the ClusterIssuer to generate certificates for the applications in your Kubernetes cluster. [Learn how to secure your Ingress resources](#secure-ingress-resources-with-cert-manager).

After the Ingress resource is ready, Cert Manager verifies the domain using HTTP01/DNS01 challenges. During this verification process, the controller log can be used to check the status, as shown below:

```text
$ kubectl get certificates
NAME                     READY   SECRET                   AGE
letencrypt-ca            False   letencrypt-ca             X
```

The status remains *False* whilst verification is in progress. This status will change to *True* when the HTTP01 verification is completed successfully.

```text
$ kubectl get certificates
NAME                     READY   SECRET                   AGE
letencrypt-ca            True    letencrypt-ca             X

$ kubectl get secrets
NAME                                  TYPE                                  DATA   AGE
letencrypt-ca                      kubernetes.io/tls                        3      Xm
```

### Secure Ingress resources with Cert Manager

Once you configure an Issuer for Cert Manager (either [a Self-Signed Issuer](#generate-tls-certificates-using-self-signed-issuers) or [an ACME Issuer](#generate-tls-certificates-using-acme-issuers)), Cert Manager will make use of this Issuer to create a TLS secret containing the certificates. Cert Manager can only create this secret if the application is already exposed. One way to do this is with an Ingress Resource which exposes the application and includes the corresponding annotations for Cert Manager.

There are two options to expose your application through an Ingress Controller using Cert Manager to manage the TLS certificates:

- Deploy another Helm chart which supports exposing the application through an Ingress controller. For instance, use the [Bitnami Helm Chart for WordPress](https://github.com/bitnami/charts/tree/main/bitnami/wordpress) and [configure Ingress for WordPress](https://github.com/bitnami/charts/tree/main/bitnami/wordpress#ingress). To enable the integration with CertManager, add the annotations below to the *ingress.annotations* parameter:

   ```text
   # Set up your ingress.class below (in this example, we are using nginx ingress controller)
   kubernetes.io/ingress.class: nginx
   cert-manager.io/cluster-issuer: letsencrypt-prod
   ```

- Create your own Ingress resource as shown in the example below:

   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: ingress-test
     annotations:
       # Set up your ingress.class below (in this example, we are using nginx ingress controller)
       kubernetes.io/ingress.class: "nginx"
       cert-manager.io/issuer: "letsencrypt-prod"
   spec:
     tls:
     # Replace the DOMAIN placeholder with the correct domain name
     - hosts:
       - DOMAIN
       secretName: letsencrypt-ca
     rules:
     # Replace the DOMAIN placeholder with the correct domain name
     - host: DOMAIN
       http:
         paths:
         - path: /
           pathType: Exact
           backend:
             service:
               name: ingress-test
               port:
                 number: 80
   ```

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `controller.affinity`, `cainjector.affinity` or `webhook.affinity` parameters. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can make use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `controller.podAffinityPreset`, `cainjector.podAffinityPreset`, `webhook.podAffinityPreset`, `controller.podAntiAffinityPreset`, `cainjector.podAntiAffinityPreset`, `webhook.podAntiAffinityPreset`, `controller.nodeAffinityPreset`, `cainjector.nodeAffinityPreset` or `webhook.nodeAffinityPreset` parameters.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value  |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`   |
| `global.storageClass`                                 | Global StorageClass for Persistent Volume(s)                                                                                                                                                                                                                                                                                                                        | `""`   |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto` |

### Common parameters

| Name                       | Description                                                                                                                                       | Value         |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| `kubeVersion`              | Override Kubernetes version                                                                                                                       | `""`          |
| `nameOverride`             | String to partially override common.names.fullname                                                                                                | `""`          |
| `fullnameOverride`         | String to fully override common.names.fullname                                                                                                    | `""`          |
| `commonLabels`             | Labels to add to all deployed objects                                                                                                             | `{}`          |
| `commonAnnotations`        | Annotations to add to all deployed objects                                                                                                        | `{}`          |
| `extraDeploy`              | Array of extra objects to deploy with the release                                                                                                 | `[]`          |
| `logLevel`                 | Set up cert-manager log level                                                                                                                     | `2`           |
| `clusterResourceNamespace` | Namespace used to store DNS provider credentials etc. for ClusterIssuer resources. If empty, uses the namespace where the controller is deployed. | `""`          |
| `leaderElection.namespace` | Namespace which leaderElection works.                                                                                                             | `kube-system` |
| `installCRDs`              | Flag to install cert-manager CRDs                                                                                                                 | `false`       |
| `replicaCount`             | Number of cert-manager replicas                                                                                                                   | `1`           |

### Controller deployment parameters

| Name                                                           | Description                                                                                                                                                                                                                             | Value                          |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `controller.replicaCount`                                      | Number of Controller replicas                                                                                                                                                                                                           | `1`                            |
| `controller.image.registry`                                    | Controller image registry                                                                                                                                                                                                               | `REGISTRY_NAME`                |
| `controller.image.repository`                                  | Controller image repository                                                                                                                                                                                                             | `REPOSITORY_NAME/cert-manager` |
| `controller.image.digest`                                      | Controller image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                              | `""`                           |
| `controller.image.pullPolicy`                                  | Controller image pull policy                                                                                                                                                                                                            | `IfNotPresent`                 |
| `controller.image.pullSecrets`                                 | Controller image pull secrets                                                                                                                                                                                                           | `[]`                           |
| `controller.image.debug`                                       | Controller image debug mode                                                                                                                                                                                                             | `false`                        |
| `controller.acmesolver.image.registry`                         | Controller image registry                                                                                                                                                                                                               | `REGISTRY_NAME`                |
| `controller.acmesolver.image.repository`                       | Controller image repository                                                                                                                                                                                                             | `REPOSITORY_NAME/acmesolver`   |
| `controller.acmesolver.image.digest`                           | Controller image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                              | `""`                           |
| `controller.acmesolver.image.pullPolicy`                       | Controller image pull policy                                                                                                                                                                                                            | `IfNotPresent`                 |
| `controller.acmesolver.image.pullSecrets`                      | Controller image pull secrets                                                                                                                                                                                                           | `[]`                           |
| `controller.acmesolver.image.debug`                            | Controller image debug mode                                                                                                                                                                                                             | `false`                        |
| `controller.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if controller.resources is set (controller.resources is recommended for production). | `nano`                         |
| `controller.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`                           |
| `controller.podSecurityContext.enabled`                        | Enabled Controller pods' Security Context                                                                                                                                                                                               | `true`                         |
| `controller.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                      | `Always`                       |
| `controller.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                          | `[]`                           |
| `controller.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                             | `[]`                           |
| `controller.podSecurityContext.fsGroup`                        | Set Controller pod's Security Context fsGroup                                                                                                                                                                                           | `1001`                         |
| `controller.containerSecurityContext.enabled`                  | Enabled controller containers' Security Context                                                                                                                                                                                         | `true`                         |
| `controller.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                        | `{}`                           |
| `controller.containerSecurityContext.runAsUser`                | Set controller containers' Security Context runAsUser                                                                                                                                                                                   | `1001`                         |
| `controller.containerSecurityContext.runAsGroup`               | Set controller containers' Security Context runAsGroup                                                                                                                                                                                  | `1001`                         |
| `controller.containerSecurityContext.runAsNonRoot`             | Set controller containers' Security Context runAsNonRoot                                                                                                                                                                                | `true`                         |
| `controller.containerSecurityContext.readOnlyRootFilesystem`   | Set read only root file system pod's Security Conte                                                                                                                                                                                     | `true`                         |
| `controller.containerSecurityContext.privileged`               | Set controller container's Security Context privileged                                                                                                                                                                                  | `false`                        |
| `controller.containerSecurityContext.allowPrivilegeEscalation` | Set controller container's Security Context allowPrivilegeEscalation                                                                                                                                                                    | `false`                        |
| `controller.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                      | `["ALL"]`                      |
| `controller.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                        | `RuntimeDefault`               |
| `controller.podAffinityPreset`                                 | Pod affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                          | `""`                           |
| `controller.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                     | `soft`                         |
| `controller.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `controller.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                    | `""`                           |
| `controller.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `controller.affinity` is set                                                                                                                                                                        | `""`                           |
| `controller.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `controller.affinity` is set                                                                                                                                                                     | `[]`                           |
| `controller.affinity`                                          | Affinity for cert-manager Controller                                                                                                                                                                                                    | `{}`                           |
| `controller.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                          | `{}`                           |
| `controller.containerPorts.http`                               | Controller HTTP container port                                                                                                                                                                                                          | `9402`                         |
| `controller.containerPorts.health`                             | Controller Health container port                                                                                                                                                                                                        | `9403`                         |
| `controller.command`                                           | Override Controller default command                                                                                                                                                                                                     | `[]`                           |
| `controller.args`                                              | Override Controller default args                                                                                                                                                                                                        | `[]`                           |
| `controller.priorityClassName`                                 | Controller pod priority class name                                                                                                                                                                                                      | `""`                           |
| `controller.runtimeClassName`                                  | Name of the runtime class to be used by pod(s)                                                                                                                                                                                          | `""`                           |
| `controller.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                          | `""`                           |
| `controller.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                          | `[]`                           |
| `controller.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                      | `true`                         |
| `controller.hostAliases`                                       | Custom host aliases for Controller pods                                                                                                                                                                                                 | `[]`                           |
| `controller.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                          | `[]`                           |
| `controller.podLabels`                                         | Extra labels for Controller pods                                                                                                                                                                                                        | `{}`                           |
| `controller.podAnnotations`                                    | Annotations for Controller pods                                                                                                                                                                                                         | `{}`                           |
| `controller.dnsPolicy`                                         | Controller pod DNS policy                                                                                                                                                                                                               | `""`                           |
| `controller.dnsConfig`                                         | Controller pod DNS config. Required if `controller.dnsPolicy` is set to `None`                                                                                                                                                          | `{}`                           |
| `controller.lifecycleHooks`                                    | Add lifecycle hooks to the Controller deployment                                                                                                                                                                                        | `{}`                           |
| `controller.updateStrategy.type`                               | Controller deployment update strategy                                                                                                                                                                                                   | `RollingUpdate`                |
| `controller.updateStrategy.rollingUpdate`                      | Controller deployment rolling update configuration parameters                                                                                                                                                                           | `{}`                           |
| `controller.extraArgs`                                         | Extra arguments to pass to the Controller container                                                                                                                                                                                     | `[]`                           |
| `controller.extraEnvVars`                                      | Add extra environment variables to the Controller container                                                                                                                                                                             | `[]`                           |
| `controller.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                                                    | `""`                           |
| `controller.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                                       | `""`                           |
| `controller.extraVolumes`                                      | Optionally specify extra list of additional volumes for Controller pods                                                                                                                                                                 | `[]`                           |
| `controller.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Controller container(s)                                                                                                                                                    | `[]`                           |
| `controller.initContainers`                                    | Add additional init containers to the Controller pods                                                                                                                                                                                   | `[]`                           |
| `controller.sidecars`                                          | Add additional sidecar containers to the Controller pod                                                                                                                                                                                 | `[]`                           |
| `controller.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                    | `true`                         |
| `controller.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                 | `60`                           |
| `controller.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                        | `10`                           |
| `controller.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                       | `1`                            |
| `controller.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                     | `3`                            |
| `controller.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                     | `1`                            |
| `controller.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                   | `true`                         |
| `controller.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                | `5`                            |
| `controller.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                       | `5`                            |
| `controller.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                      | `1`                            |
| `controller.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                    | `3`                            |
| `controller.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                    | `1`                            |
| `controller.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                     | `false`                        |
| `controller.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                  | `5`                            |
| `controller.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                         | `5`                            |
| `controller.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                        | `1`                            |
| `controller.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                      | `3`                            |
| `controller.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                      | `1`                            |
| `controller.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                          | `{}`                           |
| `controller.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                                         | `{}`                           |
| `controller.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                        | `{}`                           |
| `controller.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                                    | `true`                         |
| `controller.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                                                  | `""`                           |
| `controller.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                                    | `{}`                           |
| `controller.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                                          | `false`                        |
| `controller.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                     | `true`                         |
| `controller.networkPolicy.allowExternal`                       | Don't require client label for connections                                                                                                                                                                                              | `true`                         |
| `controller.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                         | `true`                         |
| `controller.networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                                      | `[]`                           |
| `controller.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                            | `[]`                           |
| `controller.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                            | `[]`                           |
| `controller.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                  | `{}`                           |
| `controller.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                              | `{}`                           |

### Webhook deployment parameters

| Name                                                        | Description                                                                                                                                                                                                                             | Value                                  |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `webhook.replicaCount`                                      | Number of Webhook replicas                                                                                                                                                                                                              | `1`                                    |
| `webhook.image.registry`                                    | Webhook image registry                                                                                                                                                                                                                  | `REGISTRY_NAME`                        |
| `webhook.image.repository`                                  | Webhook image repository                                                                                                                                                                                                                | `REPOSITORY_NAME/cert-manager-webhook` |
| `webhook.image.digest`                                      | Webhook image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                 | `""`                                   |
| `webhook.image.pullPolicy`                                  | Webhook image pull policy                                                                                                                                                                                                               | `IfNotPresent`                         |
| `webhook.image.pullSecrets`                                 | Webhook image pull secrets                                                                                                                                                                                                              | `[]`                                   |
| `webhook.image.debug`                                       | Webhook image debug mode                                                                                                                                                                                                                | `false`                                |
| `webhook.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if controller.resources is set (controller.resources is recommended for production). | `nano`                                 |
| `webhook.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                       | `{}`                                   |
| `webhook.podSecurityContext.enabled`                        | Enabled Webhook pods' Security Context                                                                                                                                                                                                  | `true`                                 |
| `webhook.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                      | `Always`                               |
| `webhook.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                          | `[]`                                   |
| `webhook.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                             | `[]`                                   |
| `webhook.podSecurityContext.fsGroup`                        | Set Webhook pod's Security Context fsGroup                                                                                                                                                                                              | `1001`                                 |
| `webhook.containerSecurityContext.enabled`                  | Enabled webhook containers' Security Context                                                                                                                                                                                            | `true`                                 |
| `webhook.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                        | `{}`                                   |
| `webhook.containerSecurityContext.runAsUser`                | Set webhook containers' Security Context runAsUser                                                                                                                                                                                      | `1001`                                 |
| `webhook.containerSecurityContext.runAsGroup`               | Set webhook containers' Security Context runAsGroup                                                                                                                                                                                     | `1001`                                 |
| `webhook.containerSecurityContext.runAsNonRoot`             | Set webhook containers' Security Context runAsNonRoot                                                                                                                                                                                   | `true`                                 |
| `webhook.containerSecurityContext.readOnlyRootFilesystem`   | Set read only root file system pod's Security Conte                                                                                                                                                                                     | `true`                                 |
| `webhook.containerSecurityContext.privileged`               | Set webhook container's Security Context privileged                                                                                                                                                                                     | `false`                                |
| `webhook.containerSecurityContext.allowPrivilegeEscalation` | Set webhook container's Security Context allowPrivilegeEscalation                                                                                                                                                                       | `false`                                |
| `webhook.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                      | `["ALL"]`                              |
| `webhook.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                        | `RuntimeDefault`                       |
| `webhook.podAffinityPreset`                                 | Pod affinity preset. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                             | `""`                                   |
| `webhook.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                        | `soft`                                 |
| `webhook.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `webhook.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                       | `""`                                   |
| `webhook.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `webhook.affinity` is set                                                                                                                                                                           | `""`                                   |
| `webhook.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `webhook.affinity` is set                                                                                                                                                                        | `[]`                                   |
| `webhook.affinity`                                          | Affinity for cert-manager Webhook                                                                                                                                                                                                       | `{}`                                   |
| `webhook.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                          | `{}`                                   |
| `webhook.containerPorts.https`                              | Webhook HTTPS container port                                                                                                                                                                                                            | `10250`                                |
| `webhook.containerPorts.health`                             | Webhook health container port                                                                                                                                                                                                           | `6080`                                 |
| `webhook.service.ports.https`                               | Webhook HTTPS service port                                                                                                                                                                                                              | `443`                                  |
| `webhook.command`                                           | Override Webhook default command                                                                                                                                                                                                        | `[]`                                   |
| `webhook.args`                                              | Override Webhook default args                                                                                                                                                                                                           | `[]`                                   |
| `webhook.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                    | `true`                                 |
| `webhook.livenessProbe.path`                                | Path for livenessProbe                                                                                                                                                                                                                  | `/livez`                               |
| `webhook.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                 | `60`                                   |
| `webhook.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                        | `10`                                   |
| `webhook.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                       | `1`                                    |
| `webhook.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                     | `3`                                    |
| `webhook.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                     | `1`                                    |
| `webhook.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                   | `true`                                 |
| `webhook.readinessProbe.path`                               | Path for readinessProbe                                                                                                                                                                                                                 | `/healthz`                             |
| `webhook.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                | `5`                                    |
| `webhook.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                       | `5`                                    |
| `webhook.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                      | `1`                                    |
| `webhook.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                    | `3`                                    |
| `webhook.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                    | `1`                                    |
| `webhook.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                          | `{}`                                   |
| `webhook.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                                         | `{}`                                   |
| `webhook.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                        | `{}`                                   |
| `webhook.priorityClassName`                                 | Webhook pod priority class name                                                                                                                                                                                                         | `""`                                   |
| `webhook.runtimeClassName`                                  | Name of the runtime class to be used by pod(s)                                                                                                                                                                                          | `""`                                   |
| `webhook.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                          | `""`                                   |
| `webhook.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                          | `[]`                                   |
| `webhook.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                      | `true`                                 |
| `webhook.hostAliases`                                       | Custom host aliases for Webhook pods                                                                                                                                                                                                    | `[]`                                   |
| `webhook.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                          | `[]`                                   |
| `webhook.podLabels`                                         | Extra labels for Webhook pods                                                                                                                                                                                                           | `{}`                                   |
| `webhook.podAnnotations`                                    | Annotations for Webhook pods                                                                                                                                                                                                            | `{}`                                   |
| `webhook.lifecycleHooks`                                    | Add lifecycle hooks to the Webhook deployment                                                                                                                                                                                           | `{}`                                   |
| `webhook.updateStrategy.type`                               | Webhook deployment update strategy                                                                                                                                                                                                      | `RollingUpdate`                        |
| `webhook.updateStrategy.rollingUpdate`                      | Controller deployment rolling update configuration parameters                                                                                                                                                                           | `{}`                                   |
| `webhook.extraArgs`                                         | Extra arguments to pass to the Webhook container                                                                                                                                                                                        | `[]`                                   |
| `webhook.extraEnvVars`                                      | Add extra environment variables to the Webhook container                                                                                                                                                                                | `[]`                                   |
| `webhook.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                                                    | `""`                                   |
| `webhook.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                                       | `""`                                   |
| `webhook.extraVolumes`                                      | Optionally specify extra list of additional volumes for Webhook pods                                                                                                                                                                    | `[]`                                   |
| `webhook.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Webhook container                                                                                                                                                          | `[]`                                   |
| `webhook.initContainers`                                    | Add additional init containers to the Webhook pods                                                                                                                                                                                      | `[]`                                   |
| `webhook.sidecars`                                          | Add additional sidecar containers to the Webhook pod                                                                                                                                                                                    | `[]`                                   |
| `webhook.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                                    | `true`                                 |
| `webhook.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                                                  | `""`                                   |
| `webhook.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                                    | `{}`                                   |
| `webhook.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                                          | `false`                                |
| `webhook.hostNetwork`                                       | Specifies hostNetwork value                                                                                                                                                                                                             | `false`                                |
| `webhook.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                     | `true`                                 |
| `webhook.networkPolicy.allowExternal`                       | Don't require client label for connections                                                                                                                                                                                              | `true`                                 |
| `webhook.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                         | `true`                                 |
| `webhook.networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                                      | `[]`                                   |
| `webhook.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                            | `[]`                                   |
| `webhook.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                            | `[]`                                   |
| `webhook.networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                                                  | `{}`                                   |
| `webhook.networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                                              | `{}`                                   |

### CAInjector deployment parameters

| Name                                                           | Description                                                                                                                                                                                                                                             | Value                        |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `cainjector.replicaCount`                                      | Number of CAInjector replicas                                                                                                                                                                                                                           | `1`                          |
| `cainjector.image.registry`                                    | CAInjector image registry                                                                                                                                                                                                                               | `REGISTRY_NAME`              |
| `cainjector.image.repository`                                  | CAInjector image repository                                                                                                                                                                                                                             | `REPOSITORY_NAME/cainjector` |
| `cainjector.image.digest`                                      | CAInjector image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                                                              | `""`                         |
| `cainjector.image.pullPolicy`                                  | CAInjector image pull policy                                                                                                                                                                                                                            | `IfNotPresent`               |
| `cainjector.image.pullSecrets`                                 | CAInjector image pull secrets                                                                                                                                                                                                                           | `[]`                         |
| `cainjector.image.debug`                                       | CAInjector image debug mode                                                                                                                                                                                                                             | `false`                      |
| `cainjector.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if cloneHtdocsFromGit.resources is set (cloneHtdocsFromGit.resources is recommended for production). | `nano`                       |
| `cainjector.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                                                       | `{}`                         |
| `cainjector.podSecurityContext.enabled`                        | Enabled CAInjector pods' Security Context                                                                                                                                                                                                               | `true`                       |
| `cainjector.podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                                                      | `Always`                     |
| `cainjector.podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                                                          | `[]`                         |
| `cainjector.podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                                                             | `[]`                         |
| `cainjector.podSecurityContext.fsGroup`                        | Set CAInjector pod's Security Context fsGroup                                                                                                                                                                                                           | `1001`                       |
| `cainjector.containerSecurityContext.enabled`                  | Enabled cainjector containers' Security Context                                                                                                                                                                                                         | `true`                       |
| `cainjector.containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                                                        | `{}`                         |
| `cainjector.containerSecurityContext.runAsUser`                | Set cainjector containers' Security Context runAsUser                                                                                                                                                                                                   | `1001`                       |
| `cainjector.containerSecurityContext.runAsGroup`               | Set cainjector containers' Security Context runAsGroup                                                                                                                                                                                                  | `1001`                       |
| `cainjector.containerSecurityContext.runAsNonRoot`             | Set cainjector containers' Security Context runAsNonRoot                                                                                                                                                                                                | `true`                       |
| `cainjector.containerSecurityContext.readOnlyRootFilesystem`   | Set read only root file system pod's Security Conte                                                                                                                                                                                                     | `true`                       |
| `cainjector.containerSecurityContext.privileged`               | Set cainjector container's Security Context privileged                                                                                                                                                                                                  | `false`                      |
| `cainjector.containerSecurityContext.allowPrivilegeEscalation` | Set cainjector container's Security Context allowPrivilegeEscalation                                                                                                                                                                                    | `false`                      |
| `cainjector.containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                                                      | `["ALL"]`                    |
| `cainjector.containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                                                        | `RuntimeDefault`             |
| `cainjector.podAffinityPreset`                                 | Pod affinity preset. Ignored if `cainjector.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                          | `""`                         |
| `cainjector.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `cainjector.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                     | `soft`                       |
| `cainjector.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `cainjector.affinity` is set. Allowed values: `soft` or `hard`                                                                                                                                                    | `""`                         |
| `cainjector.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `cainjector.affinity` is set                                                                                                                                                                                        | `""`                         |
| `cainjector.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `cainjector.affinity` is set                                                                                                                                                                                     | `[]`                         |
| `cainjector.affinity`                                          | Affinity for cert-manager CAInjector                                                                                                                                                                                                                    | `{}`                         |
| `cainjector.nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                                                          | `{}`                         |
| `cainjector.command`                                           | Override CAInjector default command                                                                                                                                                                                                                     | `[]`                         |
| `cainjector.args`                                              | Override CAInjector default args                                                                                                                                                                                                                        | `[]`                         |
| `cainjector.priorityClassName`                                 | CAInjector pod priority class name                                                                                                                                                                                                                      | `""`                         |
| `cainjector.runtimeClassName`                                  | Name of the runtime class to be used by pod(s)                                                                                                                                                                                                          | `""`                         |
| `cainjector.schedulerName`                                     | Name of the k8s scheduler (other than default)                                                                                                                                                                                                          | `""`                         |
| `cainjector.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                                                          | `[]`                         |
| `cainjector.automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                                                      | `true`                       |
| `cainjector.hostAliases`                                       | Custom host aliases for CAInjector pods                                                                                                                                                                                                                 | `[]`                         |
| `cainjector.tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                                                          | `[]`                         |
| `cainjector.podLabels`                                         | Extra labels for CAInjector pods                                                                                                                                                                                                                        | `{}`                         |
| `cainjector.podAnnotations`                                    | Annotations for CAInjector pods                                                                                                                                                                                                                         | `{}`                         |
| `cainjector.lifecycleHooks`                                    | Add lifecycle hooks to the CAInjector deployment                                                                                                                                                                                                        | `{}`                         |
| `cainjector.updateStrategy.type`                               | Controller deployment update strategy                                                                                                                                                                                                                   | `RollingUpdate`              |
| `cainjector.updateStrategy.rollingUpdate`                      | Controller deployment rolling update configuration parameters                                                                                                                                                                                           | `{}`                         |
| `cainjector.livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                                                                    | `true`                       |
| `cainjector.livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                                                                 | `60`                         |
| `cainjector.livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                                                        | `10`                         |
| `cainjector.livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                                                       | `1`                          |
| `cainjector.livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                                                                     | `3`                          |
| `cainjector.livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                                                                     | `1`                          |
| `cainjector.readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                                                                   | `true`                       |
| `cainjector.readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                                                                | `5`                          |
| `cainjector.readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                                                       | `5`                          |
| `cainjector.readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                                                      | `1`                          |
| `cainjector.readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                                                                    | `3`                          |
| `cainjector.readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                                                                    | `1`                          |
| `cainjector.startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                                                                     | `false`                      |
| `cainjector.startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                                                                  | `5`                          |
| `cainjector.startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                                                         | `5`                          |
| `cainjector.startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                                                        | `1`                          |
| `cainjector.startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                                                      | `3`                          |
| `cainjector.startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                                                      | `1`                          |
| `cainjector.customStartupProbe`                                | Override default startup probe                                                                                                                                                                                                                          | `{}`                         |
| `cainjector.customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                                                         | `{}`                         |
| `cainjector.customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                                                        | `{}`                         |
| `cainjector.extraArgs`                                         | Extra arguments to pass to the CAInjector container                                                                                                                                                                                                     | `[]`                         |
| `cainjector.extraEnvVars`                                      | Add extra environment variables to the CAInjector container                                                                                                                                                                                             | `[]`                         |
| `cainjector.extraEnvVarsCM`                                    | Name of existing ConfigMap containing extra env vars                                                                                                                                                                                                    | `""`                         |
| `cainjector.extraEnvVarsSecret`                                | Name of existing Secret containing extra env vars                                                                                                                                                                                                       | `""`                         |
| `cainjector.extraVolumes`                                      | Optionally specify extra list of additional volumes for CAInjector pods                                                                                                                                                                                 | `[]`                         |
| `cainjector.extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for CAInjector container(s)                                                                                                                                                                    | `[]`                         |
| `cainjector.initContainers`                                    | Add additional init containers to the CAInjector pods                                                                                                                                                                                                   | `[]`                         |
| `cainjector.sidecars`                                          | Add additional sidecar containers to the CAInjector pod                                                                                                                                                                                                 | `[]`                         |
| `cainjector.serviceAccount.create`                             | Specifies whether a ServiceAccount should be created                                                                                                                                                                                                    | `true`                       |
| `cainjector.serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                                                                                                                                                  | `""`                         |
| `cainjector.serviceAccount.annotations`                        | Additional custom annotations for the ServiceAccount                                                                                                                                                                                                    | `{}`                         |
| `cainjector.serviceAccount.automountServiceAccountToken`       | Automount service account token for the server service account                                                                                                                                                                                          | `false`                      |
| `cainjector.networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                                                                     | `true`                       |
| `cainjector.networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                                                         | `true`                       |
| `cainjector.networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                            | `[]`                         |
| `cainjector.networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                                                            | `[]`                         |

### Metrics Parameters

| Name                                       | Description                                                                       | Value      |
| ------------------------------------------ | --------------------------------------------------------------------------------- | ---------- |
| `metrics.enabled`                          | Start metrics                                                                     | `true`     |
| `metrics.podAnnotations`                   | Annotations for cert-manager exporter pods                                        | `{}`       |
| `metrics.serviceMonitor.path`              | The path which the ServiceMonitor will monitor                                    | `/metrics` |
| `metrics.serviceMonitor.targetPort`        | The port in which the ServiceMonitor will monitor                                 | `9402`     |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator      | `false`    |
| `metrics.serviceMonitor.namespace`         | Namespace which Prometheus is running in                                          | `""`       |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus. | `""`       |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped                                       | `60s`      |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                           | `30s`      |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                | `[]`       |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                         | `[]`       |
| `metrics.serviceMonitor.selector`          | ServiceMonitor selector labels                                                    | `{}`       |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                               | `{}`       |
| `metrics.serviceMonitor.additionalLabels`  | DEPRECATED. Use metrics.serviceMonitor.labels instead.                            | `{}`       |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels          | `false`    |

### Other Parameters

| Name          | Description                                        | Value  |
| ------------- | -------------------------------------------------- | ------ |
| `rbac.create` | Specifies whether RBAC resources should be created | `true` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/cert-manager \
  --set installCRDs=true
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/cert-manager
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/cert-manager/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 1.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 0.5.0

Exisiting CRDs have been syncronised with the official [cert-manager repository](https://github.com/cert-manager/cert-manager/tree/master/deploy/crds). Using the templates present in the 1.8.0 tag.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.