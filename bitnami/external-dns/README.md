<!--- app-name: ExternalDNS -->

# Bitnami package for ExternalDNS

ExternalDNS is a Kubernetes addon that configures public DNS servers with information about exposed Kubernetes services to make them discoverable.

[Overview of ExternalDNS](https://github.com/kubernetes-incubator/external-dns)

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
helm install my-release oci://registry-1.docker.io/bitnamicharts/external-dns
```

Looking to use ExternalDNS in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the commercial edition of the Bitnami catalog.

## Introduction

This chart bootstraps a [ExternalDNS](https://github.com/bitnami/containers/tree/main/bitnami/external-dns) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release oci://REGISTRY_NAME/REPOSITORY_NAME/external-dns
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

The command deploys ExternalDNS on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Configuration and installation details

### Resource requests and limits

Bitnami charts allow setting resource requests and limits for all containers inside the chart deployment. These are inside the `resources` value (check parameter table). Setting requests is essential for production workloads and these should be adapted to your specific use case.

To make this process easier, the chart contains the `resourcesPreset` values, which automatically sets the `resources` section according to different presets. Check these presets in [the bitnami/common chart](https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15). However, in production workloads using `resourcesPreset` is discouraged as it may not fully adapt to your specific needs. Find more information on container resource management in the [official Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

### [Rolling VS Immutable tags](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-understand-rolling-tags-containers-index.html)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Prometheus metrics

This chart can be integrated with Prometheus by setting `metrics.enabled` to `true`. This will expose external-dns native Prometheus endpoint in the service. It will have the necessary annotations to be automatically scraped by Prometheus.

#### Prometheus requirements

It is necessary to have a working installation of Prometheus or Prometheus Operator for the integration to work. Install the [Bitnami Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/prometheus) or the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) to easily have a working Prometheus in your cluster.

#### Integration with Prometheus Operator

The chart can deploy `ServiceMonitor` objects for integration with Prometheus Operator installations. To do so, set the value `metrics.serviceMonitor.enabled=true`. Ensure that the Prometheus Operator `CustomResourceDefinitions` are installed in the cluster or it will fail with the following error:

```text
no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Install the [Bitnami Kube Prometheus helm chart](https://github.com/bitnami/charts/tree/main/bitnami/kube-prometheus) for having the necessary CRDs and the Prometheus Operator.

### Backup and restore

To back up and restore Helm chart deployments on Kubernetes, you need to back up the persistent volumes from the source deployment and attach them to a new deployment using [Velero](https://velero.io/), a Kubernetes backup/restore tool. Find the instructions for using Velero in [this guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-backup-restore-deployments-velero-index.html).

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/main/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Using IRSA

If you are deploying to AWS EKS and you want to leverage [IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html). You will need to override `fsGroup` and `runAsUser` with `65534`(nfsnobody) and `0` respectively. Otherwise service account token will not be properly mounted.
You can use the following arguments:

```console
--set podSecurityContext.fsGroup=65534 --set podSecurityContext.runAsUser=0
```

## Tutorials

Find information about the requirements for each DNS provider on the link below:

- [ExternalDNS Tutorials](https://github.com/kubernetes-sigs/external-dns/tree/master/docs/tutorials)

For instance, to install ExternalDNS on AWS, you need to:

- Provide the K8s worker node which runs the cluster autoscaler with a minimum IAM policy (check [IAM permissions docs](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md#iam-permissions) for more information).
- Setup a hosted zone on Route53 and annotate the Hosted Zone ID and its associated "nameservers" as described on [these docs](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md#set-up-a-hosted-zone).
- Install ExternalDNS chart using the command below:

> Note: replace the placeholder HOSTED_ZONE_IDENTIFIER and HOSTED_ZONE_NAME, with your hosted zoned identifier and name, respectively.

```console
helm install my-release \
  --set provider=aws \
  --set aws.zoneType=public \
  --set txtOwnerId=HOSTED_ZONE_IDENTIFIER \
  --set domainFilters[0]=HOSTED_ZONE_NAME \
  oci://REGISTRY_NAME/REPOSITORY_NAME/external-dns
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

## Parameters

### Global parameters

| Name                                                  | Description                                                                                                                                                                                                                                                                                                                                                         | Value   |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `global.imageRegistry`                                | Global Docker image registry                                                                                                                                                                                                                                                                                                                                        | `""`    |
| `global.imagePullSecrets`                             | Global Docker registry secret names as an array                                                                                                                                                                                                                                                                                                                     | `[]`    |
| `global.security.allowInsecureImages`                 | Allows skipping image verification                                                                                                                                                                                                                                                                                                                                  | `false` |
| `global.compatibility.openshift.adaptSecurityContext` | Adapt the securityContext sections of the deployment to make them compatible with Openshift restricted-v2 SCC: remove runAsUser, runAsGroup and fsGroup and let the platform use their allowed default IDs. Possible values: auto (apply if the detected running cluster is Openshift), force (perform the adaptation always), disabled (do not perform adaptation) | `auto`  |

### Common parameters

| Name                | Description                                                                                  | Value           |
| ------------------- | -------------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`      | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname template                                      | `""`            |
| `namespaceOverride` | String to fully override common.names.namespace                                              | `""`            |
| `clusterDomain`     | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `commonLabels`      | Labels to add to all deployed objects                                                        | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects                                                   | `{}`            |
| `extraDeploy`       | Array of extra objects to deploy with the release (evaluated as a template).                 | `[]`            |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                         | `""`            |

### external-dns parameters

| Name                                                | Description                                                                                                                                                                                                       | Value                          |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| `image.registry`                                    | ExternalDNS image registry                                                                                                                                                                                        | `REGISTRY_NAME`                |
| `image.repository`                                  | ExternalDNS image repository                                                                                                                                                                                      | `REPOSITORY_NAME/external-dns` |
| `image.digest`                                      | ExternalDNS image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag                                                                                                       | `""`                           |
| `image.pullPolicy`                                  | ExternalDNS image pull policy                                                                                                                                                                                     | `IfNotPresent`                 |
| `image.pullSecrets`                                 | ExternalDNS image pull secrets                                                                                                                                                                                    | `[]`                           |
| `revisionHistoryLimit`                              | sets number of replicaset to keep in k8s                                                                                                                                                                          | `10`                           |
| `automountServiceAccountToken`                      | Mount Service Account token in pod                                                                                                                                                                                | `true`                         |
| `hostAliases`                                       | Deployment pod host aliases                                                                                                                                                                                       | `[]`                           |
| `updateStrategy`                                    | update strategy type                                                                                                                                                                                              | `{}`                           |
| `command`                                           | Override kiam default command                                                                                                                                                                                     | `[]`                           |
| `args`                                              | Override kiam default args                                                                                                                                                                                        | `[]`                           |
| `sources`                                           | K8s resources type to be observed for new DNS entries by ExternalDNS                                                                                                                                              | `[]`                           |
| `provider`                                          | DNS provider where the DNS records will be created.                                                                                                                                                               | `aws`                          |
| `initContainers`                                    | Attach additional init containers to the pod (evaluated as a template)                                                                                                                                            | `[]`                           |
| `dnsPolicy`                                         | Specifies the DNS policy for the external-dns deployment                                                                                                                                                          | `""`                           |
| `dnsConfig`                                         | allows users more control on the DNS settings for a Pod. Required if `dnsPolicy` is set to `None`                                                                                                                 | `{}`                           |
| `sidecars`                                          | Attach additional containers to the pod (evaluated as a template)                                                                                                                                                 | `[]`                           |
| `namespace`                                         | Limit sources of endpoints to a specific namespace (default: all namespaces)                                                                                                                                      | `""`                           |
| `watchReleaseNamespace`                             | Watch only namespace used for the release                                                                                                                                                                         | `false`                        |
| `fqdnTemplates`                                     | Templated strings that are used to generate DNS names from sources that don't define a hostname themselves                                                                                                        | `[]`                           |
| `containerPorts.http`                               | HTTP Container port                                                                                                                                                                                               | `7979`                         |
| `combineFQDNAnnotation`                             | Combine FQDN template and annotations instead of overwriting                                                                                                                                                      | `false`                        |
| `ignoreHostnameAnnotation`                          | Ignore hostname annotation when generating DNS names, valid only when fqdn-template is set                                                                                                                        | `false`                        |
| `publishInternalServices`                           | Allow external-dns to publish DNS records for ClusterIP services                                                                                                                                                  | `false`                        |
| `publishHostIP`                                     | Allow external-dns to publish host-ip for headless services                                                                                                                                                       | `false`                        |
| `serviceTypeFilter`                                 | The service types to take care about (default: all, options: ClusterIP, NodePort, LoadBalancer, ExternalName)                                                                                                     | `[]`                           |
| `validation.enabled`                                | Enable chart validation                                                                                                                                                                                           | `true`                         |
| `akamai.host`                                       | Hostname to use for EdgeGrid auth                                                                                                                                                                                 | `""`                           |
| `akamai.accessToken`                                | Access Token to use for EdgeGrid auth                                                                                                                                                                             | `""`                           |
| `akamai.clientToken`                                | Client Token to use for EdgeGrid auth                                                                                                                                                                             | `""`                           |
| `akamai.clientSecret`                               | When using the Akamai provider, `AKAMAI_CLIENT_SECRET` to set (optional)                                                                                                                                          | `""`                           |
| `akamai.secretName`                                 | Use an existing secret with key "akamai_api_seret" defined.                                                                                                                                                       | `""`                           |
| `alibabacloud.accessKeyId`                          | When using the Alibaba Cloud provider, set `accessKeyId` in the Alibaba Cloud configuration file (optional)                                                                                                       | `""`                           |
| `alibabacloud.accessKeySecret`                      | When using the Alibaba Cloud provider, set `accessKeySecret` in the Alibaba Cloud configuration file (optional)                                                                                                   | `""`                           |
| `alibabacloud.regionId`                             | When using the Alibaba Cloud provider, set `regionId` in the Alibaba Cloud configuration file (optional)                                                                                                          | `""`                           |
| `alibabacloud.vpcId`                                | Alibaba Cloud VPC Id                                                                                                                                                                                              | `""`                           |
| `alibabacloud.secretName`                           | Use an existing secret with key "alibaba-cloud.json" defined.                                                                                                                                                     | `""`                           |
| `alibabacloud.zoneType`                             | Zone Filter. Available values are: public, private, or no value for both                                                                                                                                          | `""`                           |
| `aws.credentials.secretKey`                         | When using the AWS provider, set `aws_secret_access_key` in the AWS credentials (optional)                                                                                                                        | `""`                           |
| `aws.credentials.accessKey`                         | When using the AWS provider, set `aws_access_key_id` in the AWS credentials (optional)                                                                                                                            | `""`                           |
| `aws.credentials.mountPath`                         | When using the AWS provider, determine `mountPath` for `credentials` secret                                                                                                                                       | `/.aws`                        |
| `aws.credentials.secretName`                        | Use an existing secret with key "credentials" defined.                                                                                                                                                            | `""`                           |
| `aws.credentials.accessKeyIDSecretRef.name`         | Define the name of the secret that stores aws_access_key_id.                                                                                                                                                      | `""`                           |
| `aws.credentials.accessKeyIDSecretRef.key`          | Define the key of the secret that stores aws_access_key_id.                                                                                                                                                       | `""`                           |
| `aws.credentials.secretAccessKeySecretRef.name`     | Define the name of the secret that stores aws_secret_access_key                                                                                                                                                   | `""`                           |
| `aws.credentials.secretAccessKeySecretRef.key`      | Define the key of the secret that stores aws_secret_access_key                                                                                                                                                    | `""`                           |
| `aws.region`                                        | When using the AWS provider, `AWS_DEFAULT_REGION` to set in the environment (optional)                                                                                                                            | `us-east-1`                    |
| `aws.zoneType`                                      | When using the AWS provider, filter for zones of this type (optional, options: public, private)                                                                                                                   | `""`                           |
| `aws.assumeRoleArn`                                 | When using the AWS provider, assume role by specifying --aws-assume-role to the external-dns daemon                                                                                                               | `""`                           |
| `aws.roleArn`                                       | Specify role ARN to the external-dns daemon                                                                                                                                                                       | `""`                           |
| `aws.apiRetries`                                    | Maximum number of retries for AWS API calls before giving up                                                                                                                                                      | `3`                            |
| `aws.batchChangeSize`                               | When using the AWS provider, set the maximum number of changes that will be applied in each batch                                                                                                                 | `1000`                         |
| `aws.zonesCacheDuration`                            | If the list of Route53 zones managed by ExternalDNS doesn't change frequently, cache it by setting a TTL                                                                                                          | `0`                            |
| `aws.zoneTags`                                      | When using the AWS provider, filter for zones with these tags                                                                                                                                                     | `[]`                           |
| `aws.preferCNAME`                                   | When using the AWS provider, replaces Alias records with CNAME (options: true, false)                                                                                                                             | `""`                           |
| `aws.evaluateTargetHealth`                          | When using the AWS provider, sets the evaluate target health flag (options: true, false)                                                                                                                          | `""`                           |
| `aws.dynamodbTable`                                 | When using the AWS provider, sets the DynamoDB table name to use for dynamodb registry                                                                                                                            | `""`                           |
| `aws.dynamodbRegion`                                | When using the AWS provider, sets the DynamoDB table region to use for dynamodb registry                                                                                                                          | `""`                           |
| `aws.zoneMatchParent`                               | When using the AWS provider, lets a domain filter match subdomains within the same zone by using their parent domain                                                                                              | `false`                        |
| `azure.secretName`                                  | When using the Azure provider, set the secret containing the `azure.json` file                                                                                                                                    | `""`                           |
| `azure.cloud`                                       | When using the Azure provider, set the Azure Cloud                                                                                                                                                                | `""`                           |
| `azure.resourceGroup`                               | When using the Azure provider, set the Azure Resource Group                                                                                                                                                       | `""`                           |
| `azure.tenantId`                                    | When using the Azure provider, set the Azure Tenant ID                                                                                                                                                            | `""`                           |
| `azure.subscriptionId`                              | When using the Azure provider, set the Azure Subscription ID                                                                                                                                                      | `""`                           |
| `azure.aadClientId`                                 | When using the Azure provider, set the Azure AAD Client ID                                                                                                                                                        | `""`                           |
| `azure.aadClientSecret`                             | When using the Azure provider, set the Azure AAD Client Secret                                                                                                                                                    | `""`                           |
| `azure.useWorkloadIdentityExtension`                | When using the Azure provider, set if you use Workload Identity extension.                                                                                                                                        | `false`                        |
| `azure.useManagedIdentityExtension`                 | When using the Azure provider, set if you use Azure MSI                                                                                                                                                           | `false`                        |
| `azure.userAssignedIdentityID`                      | When using the Azure provider with Azure MSI, set Client ID of Azure user-assigned managed identity (optional, otherwise system-assigned managed identity is used)                                                | `""`                           |
| `civo.apiToken`                                     | When using the Civo provider, `CIVO_TOKEN` to set (optional)                                                                                                                                                      | `""`                           |
| `civo.secretName`                                   | Use an existing secret with key "apiToken" defined.                                                                                                                                                               | `""`                           |
| `cloudflare.apiToken`                               | When using the Cloudflare provider, `CF_API_TOKEN` to set (optional)                                                                                                                                              | `""`                           |
| `cloudflare.apiKey`                                 | When using the Cloudflare provider, `CF_API_KEY` to set (optional)                                                                                                                                                | `""`                           |
| `cloudflare.secretName`                             | When using the Cloudflare provider, it's the name of the secret containing cloudflare_api_token or cloudflare_api_key.                                                                                            | `""`                           |
| `cloudflare.email`                                  | When using the Cloudflare provider, `CF_API_EMAIL` to set (optional). Needed when using CF_API_KEY                                                                                                                | `""`                           |
| `cloudflare.proxied`                                | When using the Cloudflare provider, enable the proxy feature (DDOS protection, CDN...) (optional)                                                                                                                 | `true`                         |
| `cloudflare.dnsRecordsPerPage`                      | Number of DNS records to fetch per page. (optional)                                                                                                                                                               | `100`                          |
| `coredns.etcdEndpoints`                             | When using the CoreDNS provider, set etcd backend endpoints (comma-separated list)                                                                                                                                | `http://etcd-extdns:2379`      |
| `coredns.etcdTLS.enabled`                           | When using the CoreDNS provider, enable secure communication with etcd                                                                                                                                            | `false`                        |
| `coredns.etcdTLS.autoGenerated`                     | Generate automatically self-signed TLS certificates                                                                                                                                                               | `false`                        |
| `coredns.etcdTLS.secretName`                        | When using the CoreDNS provider, specify a name of existing Secret with etcd certs and keys                                                                                                                       | `etcd-client-certs`            |
| `coredns.etcdTLS.mountPath`                         | When using the CoreDNS provider, set destination dir to mount data from `coredns.etcdTLS.secretName` to                                                                                                           | `/etc/coredns/tls/etcd`        |
| `coredns.etcdTLS.caFilename`                        | When using the CoreDNS provider, specify CA PEM file name from the `coredns.etcdTLS.secretName`                                                                                                                   | `ca.crt`                       |
| `coredns.etcdTLS.certFilename`                      | When using the CoreDNS provider, specify cert PEM file name from the `coredns.etcdTLS.secretName`                                                                                                                 | `cert.pem`                     |
| `coredns.etcdTLS.keyFilename`                       | When using the CoreDNS provider, specify private key PEM file name from the `coredns.etcdTLS.secretName`                                                                                                          | `key.pem`                      |
| `designate.username`                                | When using the Designate provider, specify the OpenStack authentication username. (optional)                                                                                                                      | `""`                           |
| `designate.password`                                | When using the Designate provider, specify the OpenStack authentication password. (optional)                                                                                                                      | `""`                           |
| `designate.applicationCredentialId`                 | When using the Designate provider, specify the OpenStack authentication application credential ID. This conflicts with `designate.username`. (optional)                                                           | `""`                           |
| `designate.applicationCredentialSecret`             | When using the Designate provider, specify the OpenStack authentication application credential ID. This conflicts with `designate.password`. (optional)                                                           | `""`                           |
| `designate.authUrl`                                 | When using the Designate provider, specify the OpenStack authentication Url. (optional)                                                                                                                           | `""`                           |
| `designate.regionName`                              | When using the Designate provider, specify the OpenStack region name. (optional)                                                                                                                                  | `""`                           |
| `designate.userDomainName`                          | When using the Designate provider, specify the OpenStack user domain name. (optional)                                                                                                                             | `""`                           |
| `designate.projectName`                             | When using the Designate provider, specify the OpenStack project name. (optional)                                                                                                                                 | `""`                           |
| `designate.authType`                                | When using the Designate provider, specify the OpenStack auth type. (optional)                                                                                                                                    | `""`                           |
| `designate.customCAHostPath`                        | When using the Designate provider, use a CA file already on the host to validate Openstack APIs.  This conflicts with `designate.customCA.enabled`                                                                | `""`                           |
| `designate.customCA.enabled`                        | When using the Designate provider, enable a custom CA (optional)                                                                                                                                                  | `false`                        |
| `designate.customCA.content`                        | When using the Designate provider, set the content of the custom CA                                                                                                                                               | `""`                           |
| `designate.customCA.mountPath`                      | When using the Designate provider, set the mountPath in which to mount the custom CA configuration                                                                                                                | `/config/designate`            |
| `designate.customCA.filename`                       | When using the Designate provider, set the custom CA configuration filename                                                                                                                                       | `designate-ca.pem`             |
| `exoscale.apiKey`                                   | When using the Exoscale provider, `EXTERNAL_DNS_EXOSCALE_APIKEY` to set (optional)                                                                                                                                | `""`                           |
| `exoscale.apiToken`                                 | When using the Exoscale provider, `EXTERNAL_DNS_EXOSCALE_APISECRET` to set (optional)                                                                                                                             | `""`                           |
| `exoscale.secretName`                               | Use an existing secret with keys "exoscale_api_key" and "exoscale_api_token" defined.                                                                                                                             | `""`                           |
| `digitalocean.apiToken`                             | When using the DigitalOcean provider, `DO_TOKEN` to set (optional)                                                                                                                                                | `""`                           |
| `digitalocean.secretName`                           | Use an existing secret with key "digitalocean_api_token" defined.                                                                                                                                                 | `""`                           |
| `google.project`                                    | When using the Google provider, specify the Google project (required when provider=google)                                                                                                                        | `""`                           |
| `google.batchChangeSize`                            | When using the google provider, set the maximum number of changes that will be applied in each batch                                                                                                              | `1000`                         |
| `google.serviceAccountSecret`                       | When using the Google provider, specify the existing secret which contains credentials.json (optional)                                                                                                            | `""`                           |
| `google.serviceAccountSecretKey`                    | When using the Google provider with an existing secret, specify the key name (optional)                                                                                                                           | `credentials.json`             |
| `google.serviceAccountKey`                          | When using the Google provider, specify the service account key JSON file. In this case a new secret will be created holding this service account (optional)                                                      | `""`                           |
| `google.zoneVisibility`                             | When using the Google provider, fiter for zones of a specific visibility (private or public)                                                                                                                      | `""`                           |
| `hetzner.token`                                     | When using the Hetzner provider, specify your token here. (required when `hetzner.secretName` is not provided. In this case a new secret will be created holding the token.)                                      | `""`                           |
| `hetzner.secretName`                                | When using the Hetzner provider, specify the existing secret which contains your token. Disables the usage of `hetzner.token` (optional)                                                                          | `""`                           |
| `hetzner.secretKey`                                 | When using the Hetzner provider with an existing secret, specify the key name (optional)                                                                                                                          | `hetzner_token`                |
| `infoblox.wapiUsername`                             | When using the Infoblox provider, specify the Infoblox WAPI username                                                                                                                                              | `admin`                        |
| `infoblox.wapiPassword`                             | When using the Infoblox provider, specify the Infoblox WAPI password (required when provider=infoblox)                                                                                                            | `""`                           |
| `infoblox.gridHost`                                 | When using the Infoblox provider, specify the Infoblox Grid host (required when provider=infoblox)                                                                                                                | `""`                           |
| `infoblox.view`                                     | Infoblox view                                                                                                                                                                                                     | `""`                           |
| `infoblox.secretName`                               | Existing secret name, when in place wapiUsername and wapiPassword are not required                                                                                                                                | `""`                           |
| `infoblox.domainFilter`                             | When using the Infoblox provider, specify the domain (optional)                                                                                                                                                   | `""`                           |
| `infoblox.nameRegex`                                | When using the Infoblox provider, specify the name regex filter (optional)                                                                                                                                        | `""`                           |
| `infoblox.noSslVerify`                              | When using the Infoblox provider, disable SSL verification (optional)                                                                                                                                             | `false`                        |
| `infoblox.wapiPort`                                 | When using the Infoblox provider, specify the Infoblox WAPI port (optional)                                                                                                                                       | `""`                           |
| `infoblox.wapiVersion`                              | When using the Infoblox provider, specify the Infoblox WAPI version (optional)                                                                                                                                    | `""`                           |
| `infoblox.wapiConnectionPoolSize`                   | When using the Infoblox provider, specify the Infoblox WAPI request connection pool size (optional)                                                                                                               | `""`                           |
| `infoblox.wapiHttpTimeout`                          | When using the Infoblox provider, specify the Infoblox WAPI request timeout in seconds (optional)                                                                                                                 | `""`                           |
| `infoblox.maxResults`                               | When using the Infoblox provider, specify the Infoblox Max Results (optional)                                                                                                                                     | `""`                           |
| `infoblox.createPtr`                                | When using the Infoblox provider, specify the Infoblox create PTR flag (optional)                                                                                                                                 | `false`                        |
| `linode.apiToken`                                   | When using the Linode provider, `LINODE_TOKEN` to set (optional)                                                                                                                                                  | `""`                           |
| `linode.secretName`                                 | Use an existing secret with key "linode_api_token" defined.                                                                                                                                                       | `""`                           |
| `ns1.minTTL`                                        | When using the ns1 provider, specify minimal TTL, as an integer, for records                                                                                                                                      | `10`                           |
| `ns1.apiKey`                                        | When using the ns1 provider, specify the API key to use                                                                                                                                                           | `""`                           |
| `ns1.secretName`                                    | Use an existing secret with key "ns1-api-key" defined.                                                                                                                                                            | `""`                           |
| `pihole.server`                                     | When using the Pi-hole provider, specify The address of the Pi-hole web server                                                                                                                                    | `""`                           |
| `pihole.tlsSkipVerify`                              | When using the Pi-hole provider, specify wheter to skip verification of any TLS certificates served by the Pi-hole web server                                                                                     | `""`                           |
| `pihole.password`                                   | When using the Pi-hole provider, specify a password to use                                                                                                                                                        | `""`                           |
| `pihole.secretName`                                 | Use an existing secret with key "pihole_password" defined.                                                                                                                                                        | `""`                           |
| `traefik.disableNew`                                | Disable listeners on Resources under traefik.io                                                                                                                                                                   | `false`                        |
| `traefik.disableLegacy`                             | Disable listeners on Resources under traefik.containo.us                                                                                                                                                          | `false`                        |
| `oci.region`                                        | When using the OCI provider, specify the region, where your zone is located in.                                                                                                                                   | `""`                           |
| `oci.tenancyOCID`                                   | When using the OCI provider, specify your Tenancy OCID                                                                                                                                                            | `""`                           |
| `oci.userOCID`                                      | When using the OCI provider, specify your User OCID                                                                                                                                                               | `""`                           |
| `oci.compartmentOCID`                               | When using the OCI provider, specify your Compartment OCID where your DNS Zone is located in.                                                                                                                     | `""`                           |
| `oci.privateKey`                                    | When using the OCI provider, paste in your RSA private key file for the Oracle API                                                                                                                                | `""`                           |
| `oci.privateKeyFingerprint`                         | When using the OCI provider, put in the fingerprint of your privateKey                                                                                                                                            | `""`                           |
| `oci.privateKeyPassphrase`                          | When using the OCI provider and your privateKey has a passphrase, put it in here. (optional)                                                                                                                      | `""`                           |
| `oci.secretName`                                    | When using the OCI provider, it's the name of the secret containing `oci.yaml` file.                                                                                                                              | `""`                           |
| `oci.useInstancePrincipal`                          | When using the OCI provider, enable IAM Instance Principal                                                                                                                                                        | `false`                        |
| `oci.useWorkloadIdentity`                           | When using the OCI provider, enable IAM Workload Identity                                                                                                                                                         | `false`                        |
| `ovh.consumerKey`                                   | When using the OVH provider, specify the existing consumer key. (required when provider=ovh and `ovh.secretName` is not provided.)                                                                                | `""`                           |
| `ovh.applicationKey`                                | When using the OVH provider with an existing application, specify the application key. (required when provider=ovh and `ovh.secretName` is not provided.)                                                         | `""`                           |
| `ovh.applicationSecret`                             | When using the OVH provider with an existing application, specify the application secret. (required when provider=ovh and `ovh.secretName` is not provided.)                                                      | `""`                           |
| `ovh.secretName`                                    | When using the OVH provider, it's the name of the secret containing `ovh_consumer_key`, `ovh_application_key` and `ovh_application_secret`. Disables usage of other `ovh`.                                        | `""`                           |
| `scaleway.scwAccessKey`                             | When using the Scaleway provider, specify an existing access key. (required when provider=scaleway)                                                                                                               | `""`                           |
| `scaleway.scwSecretKey`                             | When using the Scaleway provider, specify an existing secret key. (required when provider=scaleway)                                                                                                               | `""`                           |
| `scaleway.secretName`                               | Use an existing secret with keys "scaleway_access_key" and "scaleway_secret_key" defined (optional).                                                                                                              | `""`                           |
| `rfc2136.host`                                      | When using the rfc2136 provider, specify the RFC2136 host (required when provider=rfc2136)                                                                                                                        | `""`                           |
| `rfc2136.port`                                      | When using the rfc2136 provider, specify the RFC2136 port (optional)                                                                                                                                              | `53`                           |
| `rfc2136.zone`                                      | DEPRECATED: use rfc2136.zones instead.                                                                                                                                                                            | `""`                           |
| `rfc2136.zones`                                     | When using the rfc2136 provider, specify the zones (required when provider=rfc2136 and `rfc2136.zone` is not provided.)                                                                                           | `[]`                           |
| `rfc2136.tsigSecret`                                | When using the rfc2136 provider, specify the tsig secret to enable security. (do not specify if `rfc2136.secretName` is provided.) (optional)                                                                     | `""`                           |
| `rfc2136.secretName`                                | When using the rfc2136 provider, specify the existing secret which contains your tsig secret in the key "rfc2136_tsig_secret". Disables the usage of `rfc2136.tsigSecret` (optional)                              | `""`                           |
| `rfc2136.tsigSecretAlg`                             | When using the rfc2136 provider, specify the tsig secret to enable security (optional)                                                                                                                            | `hmac-sha256`                  |
| `rfc2136.tsigKeyname`                               | When using the rfc2136 provider, specify the tsig keyname to enable security (optional)                                                                                                                           | `rfc2136_tsig_secret`          |
| `rfc2136.tsigAxfr`                                  | When using the rfc2136 provider, enable AFXR to enable security (optional)                                                                                                                                        | `true`                         |
| `rfc2136.minTTL`                                    | When using the rfc2136 provider, specify minimal TTL (in duration format) for records[ns, us, ms, s, m, h], see more <https://golang.org/pkg/time/#ParseDuration>                                                 | `0s`                           |
| `rfc2136.rfc3645Enabled`                            | When using the rfc2136 provider, extend using RFC3645 to support secure updates over Kerberos with GSS-TSIG                                                                                                       | `false`                        |
| `rfc2136.kerberosConfig`                            | When using the rfc2136 provider with rfc3645Enabled, the contents of a configuration file for krb5 (optional)                                                                                                     | `""`                           |
| `rfc2136.kerberosUsername`                          | When using the rfc2136 provider with rfc3645Enabled, specify the username to authenticate with (optional)                                                                                                         | `""`                           |
| `rfc2136.kerberosPassword`                          | When using the rfc2136 provider with rfc3645Enabled, specify the password to authenticate with (optional)                                                                                                         | `""`                           |
| `rfc2136.kerberosRealm`                             | When using the rfc2136 provider with rfc3645Enabled, specify the realm to authenticate to (required when provider=rfc2136 and rfc2136.rfc3645Enabled=true)                                                        | `""`                           |
| `pdns.apiUrl`                                       | When using the PowerDNS provider, specify the API URL of the server.                                                                                                                                              | `""`                           |
| `pdns.apiPort`                                      | When using the PowerDNS provider, specify the API port of the server.                                                                                                                                             | `8081`                         |
| `pdns.apiKey`                                       | When using the PowerDNS provider, specify the API key of the server.                                                                                                                                              | `""`                           |
| `pdns.secretName`                                   | When using the PowerDNS provider, specify as secret name containing the API Key                                                                                                                                   | `""`                           |
| `transip.account`                                   | When using the TransIP provider, specify the account name.                                                                                                                                                        | `""`                           |
| `transip.apiKey`                                    | When using the TransIP provider, specify the API key to use.                                                                                                                                                      | `""`                           |
| `vinyldns.host`                                     | When using the VinylDNS provider, specify the VinylDNS API host.                                                                                                                                                  | `""`                           |
| `vinyldns.accessKey`                                | When using the VinylDNS provider, specify the Access Key to use.                                                                                                                                                  | `""`                           |
| `vinyldns.secretKey`                                | When using the VinylDNS provider, specify the Secret key to use.                                                                                                                                                  | `""`                           |
| `domainFilters`                                     | Limit possible target zones by domain suffixes (optional)                                                                                                                                                         | `[]`                           |
| `excludeDomains`                                    | Exclude subdomains (optional)                                                                                                                                                                                     | `[]`                           |
| `regexDomainFilter`                                 | Limit possible target zones by regex domain suffixes (optional)                                                                                                                                                   | `""`                           |
| `regexDomainExclusion`                              | Exclude subdomains by using regex pattern (optional)                                                                                                                                                              | `""`                           |
| `zoneNameFilters`                                   | Filter target zones by zone domain (optional)                                                                                                                                                                     | `[]`                           |
| `zoneIdFilters`                                     | Limit possible target zones by zone id (optional)                                                                                                                                                                 | `[]`                           |
| `annotationFilter`                                  | Filter sources managed by external-dns via annotation using label selector (optional)                                                                                                                             | `""`                           |
| `labelFilter`                                       | Select sources managed by external-dns using label selector (optional)                                                                                                                                            | `""`                           |
| `ingressClassFilters`                               | Filter sources managed by external-dns via IngressClass (optional)                                                                                                                                                | `[]`                           |
| `managedRecordTypesFilters`                         | Filter record types managed by external-dns (optional)                                                                                                                                                            | `[]`                           |
| `dryRun`                                            | When enabled, prints DNS record changes rather than actually performing them (optional)                                                                                                                           | `false`                        |
| `triggerLoopOnEvent`                                | When enabled, triggers run loop on create/update/delete events in addition to regular interval (optional)                                                                                                         | `false`                        |
| `interval`                                          | Interval update period to use                                                                                                                                                                                     | `1m`                           |
| `logLevel`                                          | Verbosity of the logs (options: panic, debug, info, warning, error, fatal, trace)                                                                                                                                 | `info`                         |
| `logFormat`                                         | Which format to output logs in (options: text, json)                                                                                                                                                              | `text`                         |
| `policy`                                            | Modify how DNS records are synchronized between sources and providers (options: sync, upsert-only )                                                                                                               | `upsert-only`                  |
| `registry`                                          | Registry method to use (options: txt, aws-sd, dynamodb, noop)                                                                                                                                                     | `txt`                          |
| `txtPrefix`                                         | When using the TXT registry, a prefix for ownership records that avoids collision with CNAME entries (optional)<CNAME record> (Mutual exclusive with txt-suffix)                                                  | `""`                           |
| `txtSuffix`                                         | When using the TXT registry, a suffix for ownership records that avoids collision with CNAME entries (optional)<CNAME record>.suffix (Mutual exclusive with txt-prefix)                                           | `""`                           |
| `txtOwnerId`                                        | A name that identifies this instance of ExternalDNS. Currently used by registry types: txt & aws-sd (optional)                                                                                                    | `""`                           |
| `forceTxtOwnerId`                                   | (backward compatibility) When using the non-TXT registry, it will pass the value defined by `txtOwnerId` down to the application (optional)                                                                       | `false`                        |
| `txtEncrypt.enabled`                                | Enable TXT record encryption                                                                                                                                                                                      | `false`                        |
| `txtEncrypt.aesKey`                                 | 32-byte AES-256-GCM encryption key.                                                                                                                                                                               | `""`                           |
| `txtEncrypt.secretName`                             | Use an existing secret with key "txt_aes_encryption_key" defined.                                                                                                                                                 | `""`                           |
| `extraArgs`                                         | Extra arguments to be passed to external-dns                                                                                                                                                                      | `{}`                           |
| `extraEnvVars`                                      | An array to add extra env vars                                                                                                                                                                                    | `[]`                           |
| `extraEnvVarsCM`                                    | ConfigMap containing extra env vars                                                                                                                                                                               | `""`                           |
| `extraEnvVarsSecret`                                | Secret containing extra env vars (in case of sensitive data)                                                                                                                                                      | `""`                           |
| `lifecycleHooks`                                    | Override default etcd container hooks                                                                                                                                                                             | `{}`                           |
| `schedulerName`                                     | Alternative scheduler                                                                                                                                                                                             | `""`                           |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment                                                                                                                                                                    | `[]`                           |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`                           |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`                         |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`                           |
| `nodeAffinityPreset.key`                            | Node label key to match Ignored if `affinity` is set.                                                                                                                                                             | `""`                           |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                         | `[]`                           |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`                           |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`                           |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`                           |
| `podAnnotations`                                    | Additional annotations to apply to the pod.                                                                                                                                                                       | `{}`                           |
| `podLabels`                                         | Additional labels to be added to pods                                                                                                                                                                             | `{}`                           |
| `priorityClassName`                                 | priorityClassName                                                                                                                                                                                                 | `""`                           |
| `secretAnnotations`                                 | Additional annotations to apply to the secret                                                                                                                                                                     | `{}`                           |
| `crd.create`                                        | Install and use the integrated DNSEndpoint CRD                                                                                                                                                                    | `false`                        |
| `crd.apiversion`                                    | Sets the API version for the CRD to watch                                                                                                                                                                         | `""`                           |
| `crd.kind`                                          | Sets the kind for the CRD to watch                                                                                                                                                                                | `""`                           |
| `service.enabled`                                   | Whether to create Service resource or not                                                                                                                                                                         | `true`                         |
| `service.type`                                      | Kubernetes Service type                                                                                                                                                                                           | `ClusterIP`                    |
| `service.ports.http`                                | ExternalDNS client port                                                                                                                                                                                           | `7979`                         |
| `service.nodePorts.http`                            | Port to bind to for NodePort service type (client port)                                                                                                                                                           | `""`                           |
| `service.clusterIP`                                 | IP address to assign to service                                                                                                                                                                                   | `""`                           |
| `service.externalIPs`                               | Service external IP addresses                                                                                                                                                                                     | `[]`                           |
| `service.externalName`                              | Service external name                                                                                                                                                                                             | `""`                           |
| `service.loadBalancerIP`                            | IP address to assign to load balancer (if supported)                                                                                                                                                              | `""`                           |
| `service.loadBalancerSourceRanges`                  | List of IP CIDRs allowed access to load balancer (if supported)                                                                                                                                                   | `[]`                           |
| `service.externalTrafficPolicy`                     | Enable client source IP preservation                                                                                                                                                                              | `Cluster`                      |
| `service.extraPorts`                                | Extra ports to expose in the service (normally used with the `sidecar` value)                                                                                                                                     | `[]`                           |
| `service.annotations`                               | Annotations to add to service                                                                                                                                                                                     | `{}`                           |
| `service.labels`                                    | Provide any additional labels which may be required.                                                                                                                                                              | `{}`                           |
| `service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                                                                                                              | `None`                         |
| `service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                                                                                                       | `{}`                           |
| `networkPolicy.enabled`                             | Specifies whether a NetworkPolicy should be created                                                                                                                                                               | `true`                         |
| `networkPolicy.allowExternal`                       | Don't require server label for connections                                                                                                                                                                        | `true`                         |
| `networkPolicy.allowExternalEgress`                 | Allow the pod to access any range of port and all destinations.                                                                                                                                                   | `true`                         |
| `networkPolicy.kubeAPIServerPorts`                  | List of possible endpoints to kube-apiserver (limit to your cluster settings to increase security)                                                                                                                | `[]`                           |
| `networkPolicy.extraIngress`                        | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                           |
| `networkPolicy.extraEgress`                         | Add extra ingress rules to the NetworkPolicy                                                                                                                                                                      | `[]`                           |
| `networkPolicy.ingressNSMatchLabels`                | Labels to match to allow traffic from other namespaces                                                                                                                                                            | `{}`                           |
| `networkPolicy.ingressNSPodMatchLabels`             | Pod labels to match to allow traffic from other namespaces                                                                                                                                                        | `{}`                           |
| `serviceAccount.create`                             | Determine whether a Service Account should be created or it should reuse a exiting one.                                                                                                                           | `true`                         |
| `serviceAccount.name`                               | ServiceAccount to use. A name is generated using the common.names.fullname template if it is not set                                                                                                              | `""`                           |
| `serviceAccount.annotations`                        | Additional Service Account annotations                                                                                                                                                                            | `{}`                           |
| `serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account.                                                                                                                                                                  | `false`                        |
| `serviceAccount.labels`                             | Additional labels to be included on the service account                                                                                                                                                           | `{}`                           |
| `rbac.create`                                       | Whether to create & use RBAC resources or not                                                                                                                                                                     | `true`                         |
| `rbac.clusterRole`                                  | Whether to create Cluster Role. When set to false creates a Role in `namespace`                                                                                                                                   | `true`                         |
| `rbac.apiVersion`                                   | Version of the RBAC API                                                                                                                                                                                           | `v1`                           |
| `rbac.pspEnabled`                                   | Whether to create a PodSecurityPolicy. WARNING: PodSecurityPolicy is deprecated in Kubernetes v1.21 or later, unavailable in v1.25 or later                                                                       | `false`                        |
| `containerSecurityContext.enabled`                  | Enabled Apache Server containers' Security Context                                                                                                                                                                | `true`                         |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                                                                                                  | `{}`                           |
| `containerSecurityContext.runAsUser`                | Set ExternalDNS containers' Security Context runAsUser                                                                                                                                                            | `1001`                         |
| `containerSecurityContext.runAsGroup`               | Set ExternalDNS containers' Security Context runAsGroup                                                                                                                                                           | `1001`                         |
| `containerSecurityContext.runAsNonRoot`             | Set ExternalDNS container's Security Context runAsNonRoot                                                                                                                                                         | `true`                         |
| `containerSecurityContext.privileged`               | Set primary container's Security Context privileged                                                                                                                                                               | `false`                        |
| `containerSecurityContext.allowPrivilegeEscalation` | Set primary container's Security Context allowPrivilegeEscalation                                                                                                                                                 | `false`                        |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                                                                                                                | `["ALL"]`                      |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container readonlyRootFilesystem                                                                                                                                                                              | `true`                         |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                                                                                                  | `RuntimeDefault`               |
| `podSecurityContext.enabled`                        | Enable pod security context                                                                                                                                                                                       | `true`                         |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                                                                                                                | `Always`                       |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                                                                                                    | `[]`                           |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                                                                                                       | `[]`                           |
| `podSecurityContext.fsGroup`                        | Group ID for the container                                                                                                                                                                                        | `1001`                         |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `nano`                         |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`                           |
| `livenessProbe.enabled`                             | Enable livenessProbe                                                                                                                                                                                              | `true`                         |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `10`                           |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`                           |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`                            |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `2`                            |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`                            |
| `readinessProbe.enabled`                            | Enable readinessProbe                                                                                                                                                                                             | `true`                         |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `5`                            |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`                           |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `5`                            |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`                            |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`                            |
| `startupProbe.enabled`                              | Enable startupProbe                                                                                                                                                                                               | `false`                        |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `5`                            |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`                           |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`                            |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `6`                            |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`                            |
| `customLivenessProbe`                               | Override default liveness probe                                                                                                                                                                                   | `{}`                           |
| `customReadinessProbe`                              | Override default readiness probe                                                                                                                                                                                  | `{}`                           |
| `customStartupProbe`                                | Override default startup probe                                                                                                                                                                                    | `{}`                           |
| `extraVolumes`                                      | A list of volumes to be added to the pod                                                                                                                                                                          | `[]`                           |
| `extraVolumeMounts`                                 | A list of volume mounts to be added to the pod                                                                                                                                                                    | `[]`                           |
| `pdb.create`                                        | Enable/disable a Pod Disruption Budget creation                                                                                                                                                                   | `true`                         |
| `pdb.minAvailable`                                  | Minimum number/percentage of pods that should remain scheduled                                                                                                                                                    | `""`                           |
| `pdb.maxUnavailable`                                | Maximum number/percentage of pods that may be made unavailable. Defaults to `1` if both `pdb.minAvailable` and `pdb.maxUnavailable` are empty.                                                                    | `""`                           |
| `metrics.enabled`                                   | Enable prometheus to access external-dns metrics endpoint                                                                                                                                                         | `false`                        |
| `metrics.podAnnotations`                            | Annotations for enabling prometheus to access the metrics endpoint                                                                                                                                                | `{}`                           |
| `metrics.serviceMonitor.enabled`                    | Create ServiceMonitor object                                                                                                                                                                                      | `false`                        |
| `metrics.serviceMonitor.namespace`                  | Namespace in which Prometheus is running                                                                                                                                                                          | `""`                           |
| `metrics.serviceMonitor.interval`                   | Interval at which metrics should be scraped                                                                                                                                                                       | `""`                           |
| `metrics.serviceMonitor.scrapeTimeout`              | Timeout after which the scrape is ended                                                                                                                                                                           | `""`                           |
| `metrics.serviceMonitor.selector`                   | Additional labels for ServiceMonitor object                                                                                                                                                                       | `{}`                           |
| `metrics.serviceMonitor.metricRelabelings`          | Specify Metric Relabelings to add to the scrape endpoint                                                                                                                                                          | `[]`                           |
| `metrics.serviceMonitor.relabelings`                | Prometheus relabeling rules                                                                                                                                                                                       | `[]`                           |
| `metrics.serviceMonitor.honorLabels`                | Specify honorLabels parameter to add the scrape endpoint                                                                                                                                                          | `false`                        |
| `metrics.serviceMonitor.labels`                     | Used to pass Labels that are required by the installed Prometheus Operator                                                                                                                                        | `{}`                           |
| `metrics.serviceMonitor.targetLabels`               | Labels from the Kubernetes service to be transferred to the created metrics                                                                                                                                       | `[]`                           |
| `metrics.serviceMonitor.podTargetLabels`            | Labels from the Kubernetes pod to be transferred to the created metrics                                                                                                                                           | `[]`                           |
| `metrics.serviceMonitor.annotations`                | Additional custom annotations for the ServiceMonitor                                                                                                                                                              | `{}`                           |
| `metrics.serviceMonitor.jobLabel`                   | The name of the label on the target service to use as the job name in prometheus.                                                                                                                                 | `""`                           |
| `metrics.googlePodMonitor.enabled`                  | Create Google Managed Prometheus PodMonitoring object                                                                                                                                                             | `false`                        |
| `metrics.googlePodMonitor.namespace`                | Namespace in which PodMonitoring created                                                                                                                                                                          | `""`                           |
| `metrics.googlePodMonitor.interval`                 | Interval at which metrics should be scraped by Google Managed Prometheus                                                                                                                                          | `60s`                          |
| `metrics.googlePodMonitor.endpoint`                 | The endpoint for Google Managed Prometheus scraping the metrics                                                                                                                                                   | `/metrics`                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set provider=aws oci://REGISTRY_NAME/REPOSITORY_NAME/external-dns
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml oci://REGISTRY_NAME/REPOSITORY_NAME/external-dns
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.
> **Tip**: You can use the default [values.yaml](https://github.com/bitnami/charts/tree/main/bitnami/external-dns/values.yaml)

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 8.7.0

This version introduces image verification for security purposes. To disable it, set `global.security.allowInsecureImages` to `true`. More details at [GitHub issue](https://github.com/bitnami/charts/issues/30850).

### To 7.0.0

This major bump changes the following security defaults:

- `runAsGroup` is changed from `0` to `1001`
- `readOnlyRootFilesystem` is set to `true`
- `resourcesPreset` is changed from `none` to the minimum size working in our test suites (NOTE: `resourcesPreset` is not meant for production usage, but `resources` adapted to your use case).
- `global.compatibility.openshift.adaptSecurityContext` is changed from `disabled` to `auto`.

This could potentially break any customization or init scripts used in your deployment. If this is the case, change the default values to the previous ones.

### To 6.0.0

Some of the chart values were changed to adapt to the latest Bitnami standards. More specifically:

- `containerPort` was changed to `containerPorts.http`
- `service.port` was changed to `service.ports.http`

No issues should be expected when upgrading.

### To 5.0.0

The CRD was updated according to the latest changes in the upstream project. As a consequence, the CRD API version was moved from `apiextensions.k8s.io/v1beta1` to `apiextensions.k8s.io/v1`. If you deployed the Helm Chart using `crd.create=true` you need to manually delete the old CRD before upgrading the release.

```console
kubectl delete crd dnsendpoints.externaldns.k8s.io
helm upgrade my-release -f my-values.yaml
```

### To 4.3.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/main/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated thechart dependencies before executing any upgrade.

### To 4.0.0

[On November 13, 2020, Helm v2 support was formally finished](https://github.com/helm/charts#status-of-the-project), this major version is the result of the required changes applied to the Helm Chart to be able to incorporate the different features added in Helm v3 and to be consistent with the Helm project itself regarding the Helm v2 EOL.

#### What changes were introduced in this major version?

- Previous versions of this Helm Chart use `apiVersion: v1` (installable by both Helm 2 and 3), this Helm Chart was updated to `apiVersion: v2` (installable by Helm 3 only). [Here](https://helm.sh/docs/topics/charts/#the-apiversion-field) you can find more information about the `apiVersion` field.
- The different fields present in the *Chart.yaml* file has been ordered alphabetically in a homogeneous way for all the Bitnami Helm Charts

#### Considerations when upgrading to this version

- If you want to upgrade to this version from a previous one installed with Helm v3, you shouldn't face any issues
- If you want to upgrade to this version using Helm v2, this scenario is not supported as this version doesn't support Helm v2 anymore
- If you installed the previous version with Helm v2 and wants to upgrade to this version with Helm v3, please refer to the [official Helm documentation](https://helm.sh/docs/topics/v2_v3_migration/#migration-use-cases) about migrating from Helm v2 to v3

#### Useful links

- <https://techdocs.broadcom.com/us/en/vmware-tanzu/application-catalog/tanzu-application-catalog/services/tac-doc/apps-tutorials-resolve-helm2-helm3-post-migration-issues-index.html>
- <https://helm.sh/docs/topics/v2_v3_migration/>
- <https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/>

### To 3.0.0

- The parameters below are renamed:
  - `rbac.serviceAccountCreate` -> `serviceAccount.create`
  - `rbac.serviceAccountName` -> `serviceAccount.name`
  - `rbac.serviceAccountAnnotations` -> `serviceAccount.annotations`
- It is now possible to create serviceAccount, clusterRole and clusterRoleBinding manually and give the serviceAccount to the chart.

### To 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is `my-release`:

```console
kubectl delete deployment my-release-external-dns
helm upgrade my-release oci://REGISTRY_NAME/REPOSITORY_NAME/external-dns
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Bitnami, you need to use `REGISTRY_NAME=registry-1.docker.io` and `REPOSITORY_NAME=bitnamicharts`.

Other mayor changes included in this major version are:

- Default image changes from `registry.opensource.zalan.do/teapot/external-dns` to `bitnami/external-dns`.
- The parameters below are renamed:
  - `aws.secretKey` -> `aws.credentials.secretKey`
  - `aws.accessKey` -> `aws.credentials.accessKey`
  - `aws.credentialsPath` -> `aws.credentials.mountPath`
  - `designate.customCA.directory` -> `designate.customCA.mountPath`
- Support to Prometheus metrics is added.

## License

Copyright &copy; 2025 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.