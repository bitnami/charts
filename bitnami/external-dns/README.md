# external-dns

[ExternalDNS](https://github.com/kubernetes-sigs/external-dns) is a Kubernetes addon that configures public DNS servers with information about exposed Kubernetes services to make them discoverable.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/external-dns
```

## Introduction

This chart bootstraps a [ExternalDNS](https://github.com/bitnami/bitnami-docker-external-dns) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bitnami/external-dns
```

The command deploys ExternalDNS on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the external-dns chart and their default values.

| Parameter                              | Description                                                                                                                                                                                                     | Default                                                 |
|----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                 | Global Docker image registry                                                                                                                                                                                    | `nil`                                                   |
| `global.imagePullSecrets`              | Global Docker registry secret names as an array                                                                                                                                                                 | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                       | ExternalDNS image registry                                                                                                                                                                                      | `docker.io`                                             |
| `image.repository`                     | ExternalDNS Image name                                                                                                                                                                                          | `bitnami/external-dns`                                  |
| `image.tag`                            | ExternalDNS Image tag                                                                                                                                                                                           | `{TAG_NAME}`                                            |
| `image.pullPolicy`                     | ExternalDNS image pull policy                                                                                                                                                                                   | `IfNotPresent`                                          |
| `image.pullSecrets`                    | Specify docker-registry secret names as an array                                                                                                                                                                | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                         | String to partially override external-dns.fullname template with a string (will prepend the release name)                                                                                                       | `nil`                                                   |
| `fullnameOverride`                     | String to fully override external-dns.fullname template with a string                                                                                                                                           | `nil`                                                   |
| `sources`                              | K8s resources type to be observed for new DNS entries by ExternalDNS                                                                                                                                            | `[service, ingress]`                                    |
| `provider`                             | DNS provider where the DNS records will be created (mandatory) (options: aws, azure, google, ...)                                                                                                               | `aws`                                                   |
| `namespace`                            | Limit sources of endpoints to a specific namespace (default: all namespaces)                                                                                                                                    | `""`                                                    |
| `fqdnTemplates`                        | Templated strings that are used to generate DNS names from sources that don't define a hostname themselves                                                                                                      | `[]`                                                    |
| `combineFQDNAnnotation`                | Combine FQDN template and annotations instead of overwriting                                                                                                                                                    | `false`                                                 |
| `hostAliases`                          | Add deployment host aliases                                                                                                                                                                                     | `[]`                                                    |
| `ignoreHostnameAnnotation`             | Ignore hostname annotation when generating DNS names, valid only when fqdn-template is set                                                                                                                      | `false`                                                 |
| `publishInternalServices`              | Whether to publish DNS records for ClusterIP services or not                                                                                                                                                    | `false`                                                 |
| `publishHostIP`                        | Allow external-dns to publish host-ip for headless services                                                                                                                                                     | `false`                                                 |
| `serviceTypeFilter`                    | The service types to take care about (default: all, options: ClusterIP, NodePort, LoadBalancer, ExternalName)                                                                                                   | `[]`                                                    |
| `alibabacloud.accessKeyId`             | When using the Alibaba Cloud provider, set `accessKeyId` in the Alibaba Cloud configuration file (optional)                                                                                                     | `""`                                                    |
| `alibabacloud.accessKeySecret`         | When using the Alibaba Cloud provider, set `accessKeySecret` in the Alibaba Cloud configuration file (optional)                                                                                                 | `""`                                                    |
| `alibabacloud.regionId`                | When using the Alibaba Cloud provider, set `regionId` in the Alibaba Cloud configuration file (optional)                                                                                                        | `""`                                                    |
| `alibabacloud.zoneType`                | When using the Alibaba Cloud provider, filter for zones of this type (optional, options: public, private)                                                                                                       | `""`                                                    |
| `aws.credentials.accessKey`            | When using the AWS provider, set `aws_access_key_id` in the AWS credentials (optional)                                                                                                                          | `""`                                                    |
| `aws.credentials.secretKey`            | When using the AWS provider, set `aws_secret_access_key` in the AWS credentials (optional)                                                                                                                      | `""`                                                    |
| `aws.credentials.mountPath`            | When using the AWS provider, determine `mountPath` for `credentials` secret                                                                                                                                     | `"/.aws"`                                               |
| `aws.region`                           | When using the AWS provider, `AWS_DEFAULT_REGION` to set in the environment (optional)                                                                                                                          | `us-east-1`                                             |
| `aws.apiRetries`                       | Maximum number of retries for AWS API calls before giving up                                                                                                                                                    | `3`                                                     |
| `aws.zoneType`                         | When using the AWS provider, filter for zones of this type (optional, options: public, private)                                                                                                                 | `""`                                                    |
| `aws.assumeRoleArn`                    | When using the AWS provider, assume role by specifying --aws-assume-role to the external-dns daemon                                                                                                             | `""`                                                    |
| `aws.batchChangeSize`                  | When using the AWS provider, set the maximum number of changes that will be applied in each batch                                                                                                               | `1000`                                                  |
| `aws.zoneTags`                         | When using the AWS provider, filter for zones with these tags                                                                                                                                                   | `[]`                                                    |
| `aws.preferCNAME`                      | When using the AWS provider, replaces Alias records with CNAME (options: true, false)                                                                                                                           | `[]`                                                    |
| `aws.evaluateTargetHealth`             | When using the AWS provider, sets the evaluate target health flag (options: true, false)                                                                                                                        | `[true, false]`                                         |
| `azure.secretName`                     | When using the Azure provider, set the secret containing the `azure.json` file                                                                                                                                  | `""`                                                    |
| `azure.cloud`                          | When using the Azure provider, set the Azure Cloud                                                                                                                                                              | `""`                                                    |
| `azure.resourceGroup`                  | When using the Azure provider, set the Azure Resource Group                                                                                                                                                     | `""`                                                    |
| `azure.tenantId`                       | When using the Azure provider, set the Azure Tenant ID                                                                                                                                                          | `""`                                                    |
| `azure.subscriptionId`                 | When using the Azure provider, set the Azure Subscription ID                                                                                                                                                    | `""`                                                    |
| `azure.aadClientId`                    | When using the Azure provider, set the Azure AAD Client ID                                                                                                                                                      | `""`                                                    |
| `azure.aadClientSecret`                | When using the Azure provider, set the Azure AAD Client Secret                                                                                                                                                  | `""`                                                    |
| `azure.useManagedIdentityExtension`    | When using the Azure provider, set if you use Azure MSI                                                                                                                                                         | `""`                                                    |
| `azure.userAssignedIdentityID`         | When using the Azure provider with Azure MSI, set Client ID of Azure user-assigned managed identity (optional, otherwise system-assigned managed identity is used)                                              | `""`                                                    |
| `cloudflare.apiToken`                  | When using the Cloudflare provider, `CF_API_TOKEN` to set (optional)                                                                                                                                            | `""`                                                    |
| `cloudflare.apiKey`                    | When using the Cloudflare provider, `CF_API_KEY` to set (optional)                                                                                                                                              | `""`                                                    |
| `cloudflare.email`                     | When using the Cloudflare provider, `CF_API_EMAIL` to set (optional). Needed when using CF_API_KEY                                                                                                              | `""`                                                    |
| `cloudflare.proxied`                   | When using the Cloudflare provider, enable the proxy feature (DDOS protection, CDN...) (optional)                                                                                                               | `true`                                                  |
| `cloudflare.secretName`                | When using the Cloudflare provider, it's the name of the secret containing cloudflare_api_token or cloudflare_api_key.                                                                                          | `""`                                                    |
| `coredns.etcdEndpoints`                | When using the CoreDNS provider, set etcd backend endpoints (comma-separated list)                                                                                                                              | `"http://etcd-extdns:2379"`                             |
| `coredns.etcdTLS.enabled`              | When using the CoreDNS provider, enable secure communication with etcd                                                                                                                                          | `false`                                                 |
| `coredns.etcdTLS.secretName`           | When using the CoreDNS provider, specify a name of existing Secret with etcd certs and keys                                                                                                                     | `"etcd-client-certs"`                                   |
| `coredns.etcdTLS.mountPath`            | When using the CoreDNS provider, set destination dir to mount data from `coredns.etcdTLS.secretName` to                                                                                                         | `"/etc/coredns/tls/etcd"`                               |
| `coredns.etcdTLS.caFilename`           | When using the CoreDNS provider, specify CA PEM file name from the `coredns.etcdTLS.secretName`                                                                                                                 | `"ca.crt"`                                              |
| `coredns.etcdTLS.certFilename`         | When using the CoreDNS provider, specify cert PEM file name from the `coredns.etcdTLS.secretName`                                                                                                               | `"cert.pem"`                                            |
| `coredns.etcdTLS.keyFilename`          | When using the CoreDNS provider, specify private key PEM file name from the `coredns.etcdTLS.secretName`                                                                                                        | `"key.pem"`                                             |
| `designate.authUrl`                    | When using the Designate provider, specify the OpenStack authentication Url. (optional)                                                                                                                         | `none`                                                  |
| `designate.customCA.enabled`           | When using the Designate provider, enable a custom CA (optional)                                                                                                                                                | false                                                   |
| `designate.customCA.content`           | When using the Designate provider, set the content of the custom CA                                                                                                                                             | ""                                                      |
| `designate.customCA.mountPath`         | When using the Designate provider, set the mountPath in which to mount the custom CA configuration                                                                                                              | "/config/designate"                                     |
| `designate.customCA.filename`          | When using the Designate provider, set the custom CA configuration filename                                                                                                                                     | "designate-ca.pem"                                      |
| `designate.customCAHostPath`           | When using the Designate provider, use a CA file already on the host to validate Openstack APIs.  This conflicts with `designate.customCA.enabled`                                                              | `none`                                                  |
| `designate.password`                   | When using the Designate provider, specify the OpenStack authentication password. (optional)                                                                                                                    | `none`                                                  |
| `designate.projectName`                | When using the Designate provider, specify the OpenStack project name. (optional)                                                                                                                               | `none`                                                  |
| `designate.regionName`                 | When using the Designate provider, specify the OpenStack region name. (optional)                                                                                                                                | `none`                                                  |
| `designate.userDomainName`             | When using the Designate provider, specify the OpenStack user domain name. (optional)                                                                                                                           | `none`                                                  |
| `designate.username`                   | When using the Designate provider, specify the OpenStack authentication username. (optional)                                                                                                                    | `none`                                                  |
| `digitalocean.apiToken`                | When using the DigitalOcean provider, `DO_TOKEN` to set (optional)                                                                                                                                              | `""`                                                    |
| `google.project`                       | When using the Google provider, specify the Google project (required when provider=google)                                                                                                                      | `""`                                                    |
| `google.serviceAccountSecret`          | When using the Google provider, specify the existing secret which contains credentials.json (optional)                                                                                                          | `""`                                                    |
| `google.serviceAccountSecretKey`       | When using the Google provider with an existing secret, specify the key name (optional)                                                                                                                         | `"credentials.json"`                                    |
| `google.serviceAccountKey`             | When using the Google provider, specify the service account key JSON file. (required when `google.serviceAccountSecret` is not provided. In this case a new secret will be created holding this service account | `""`                                                    |
| `hetzner.secretName`                   | When using the Hetzner provider, specify the existing secret which contains your token. Disables the usage of `hetzner.token` (optional)                                                                        | `""`                                                    |
| `hetzner.secretKey`                    | When using the Hetzner provider with an existing secret, specify the key name (optional)                                                                                                                        | `"hetzner_token"`                                       |
| `hetzner.token`                        | When using the Hetzner provider, specify your token here. (required when `hetzner.secretName` is not provided. In this case a new secret will be created holding the token.)                                    | `""`                                                    |
| `ovh.consumerKey`                      | When using the OVH provider, specify the existing consumer key. (required when provider=ovh)                                                                                                                    | `""`                                                    |
| `ovh.applicationKey`                   | When using the OVH provider with an existing application, specify the application key. (required when provider=ovh)                                                                                             | `""`                                                    |
| `ovh.applicationSecret`                | When using the OVH provider with an existing application, specify the application secret. (required when provider=ovh)                                                                                          | `""`                                                    |
| `scaleway.scwAccessKey`                | When using the Scaleway provider, specify an existing access key. (required when provider=scaleway)                                                                                                             | `""`                                                    |
| `scaleway.scwSecretKey`                | When using the Scaleway provider, specify an existing secret key. (required when provider=scaleway)                                                                                                             | `""`                                                    |
| `scaleway.scwDefaultOrganizationId`    | When using the Scaleway provider, specify the existing organization id. (required when provider=scaleway)                                                                                                       | `""`                                                    |
| `infoblox.gridHost`                    | When using the Infoblox provider, specify the Infoblox Grid host (required when provider=infoblox)                                                                                                              | `""`                                                    |
| `infoblox.wapiUsername`                | When using the Infoblox provider, specify the Infoblox WAPI username                                                                                                                                            | `"admin"`                                               |
| `infoblox.wapiPassword`                | When using the Infoblox provider, specify the Infoblox WAPI password (required when provider=infoblox)                                                                                                          | `""`                                                    |
| `infoblox.domainFilter`                | When using the Infoblox provider, specify the domain (optional)                                                                                                                                                 | `""`                                                    |
| `infoblox.secretName`                  | When using the Infoblox provider, specify a name of existing Secret with wapiUsername and wapiPassword (optional)                                                                                               | `""`                                                    |
| `infoblox.noSslVerify`                 | When using the Infoblox provider, disable SSL verification (optional)                                                                                                                                           | `false`                                                 |
| `infoblox.wapiPort`                    | When using the Infoblox provider, specify the Infoblox WAPI port (optional)                                                                                                                                     | `""`                                                    |
| `infoblox.wapiVersion`                 | When using the Infoblox provider, specify the Infoblox WAPI version (optional)                                                                                                                                  | `""`                                                    |
| `infoblox.wapiConnectionPoolSize`      | When using the Infoblox provider, specify the Infoblox WAPI request connection pool size (optional)                                                                                                             | `""`                                                    |
| `infoblox.wapiHttpTimeout`             | When using the Infoblox provider, specify the Infoblox WAPI request timeout in seconds (optional)                                                                                                               | `""`                                                    |
| `linode.apiToken`                      | When using the Linode provider, `LINODE_TOKEN` to set (optional)                                                                                                                                                | `""`                                                    |
| `rfc2136.host`                         | When using the rfc2136 provider, specify the RFC2136 host (required when provider=rfc2136)                                                                                                                      | `""`                                                    |
| `rfc2136.port`                         | When using the rfc2136 provider, specify the RFC2136 port (optional)                                                                                                                                            | `53`                                                    |
| `rfc2136.zone`                         | When using the rfc2136 provider, specify the zone (required when provider=rfc2136)                                                                                                                              | `""`                                                    |
| `rfc2136.tsigSecret`                   | When using the rfc2136 provider, specify the tsig secret to enable security (optional)                                                                                                                          | `""`                                                    |
| `rfc2136.tsigKeyname`                  | When using the rfc2136 provider, specify the tsig keyname to enable security (optional)                                                                                                                         | `"externaldns-key"`                                     |
| `rfc2136.tsigSecretAlg`                | When using the rfc2136 provider, specify the tsig secret to enable security (optional)                                                                                                                          | `"hmac-sha256"`                                         |
| `rfc2136.tsigAxfr`                     | When using the rfc2136 provider, enable AFXR to enable security (optional)                                                                                                                                      | `true`                                                  |
| `rfc2136.minTTL`                       | When using the rfc2136 provider, specify minimal TTL (in duration format) for records                                                                                                                           | `"0s"`                                                  |
| `pdns.apiUrl`                          | When using the PowerDNS provider, specify the API URL of the server.                                                                                                                                            | `""`                                                    |
| `pdns.apiPort`                         | When using the PowerDNS provider, specify the API port of the server.                                                                                                                                           | `8081`                                                  |
| `pdns.apiKey`                          | When using the PowerDNS provider, specify the API key of the server.                                                                                                                                            | `""`                                                    |
| `pdns.secretName`                      | When using the PowerDNS provider, specify as secret name containing the API Key                                                                                                                                 | `""`                                                    |
| `transip.account`                      | When using the TransIP provider, specify the account name.                                                                                                                                                      | `""`                                                    |
| `transip.apiKey`                       | When using the TransIP provider, specify the API key to use.                                                                                                                                                    | `""`                                                    |
| `vinyldns.host`                        | When using the VinylDNS provider, specify the VinylDNS API host.                                                                                                                                                | `""`                                                    |
| `vinyldns.accessKey`                   | When using the VinylDNS provider, specify the Access Key to use.                                                                                                                                                | `""`                                                    |
| `vinyldns.secretKey`                   | When using the VinylDNS provider, specify the Secret key to use.                                                                                                                                                | `""`                                                    |
| `annotationFilter`                     | Filter sources managed by external-dns via annotation using label selector (optional)                                                                                                                           | `""`                                                    |
| `domainFilters`                        | Limit possible target zones by domain suffixes (optional)                                                                                                                                                       | `[]`                                                    |
| `excludeDomains`                       | Exclude subdomains (optional)                                                                                                                                                                                   | `[]`                                                    |
| `zoneNameFilters`                        | Filter target zones by zone domain (optional)                                                                                                                                                               | `[]`                                                    |
| `zoneIdFilters`                        | Limit possible target zones by zone id (optional)                                                                                                                                                               | `[]`                                                    |
| `crd.create`                           | Install and use the integrated DNSEndpoint CRD                                                                                                                                                                  | `false`                                                 |
| `crd.apiversion`                       | Sets the API version for the CRD to watch                                                                                                                                                                       | `""`                                                    |
| `crd.kind`                             | Sets the kind for the CRD to watch                                                                                                                                                                              | `""`                                                    |
| `dryRun`                               | When enabled, prints DNS record changes rather than actually performing them (optional)                                                                                                                         | `false`                                                 |
| `logLevel`                             | Verbosity of the logs (options: panic, debug, info, warning, error, fatal, trace)                                                                                                                               | `info`                                                  |
| `logFormat`                            | Which format to output logs in (options: text, json)                                                                                                                                                            | `text`                                                  |
| `interval`                             | Interval update period to use                                                                                                                                                                                   | `1m`                                                    |
| `triggerLoopOnEvent`                   | When enabled, triggers run loop on create/update/delete events in addition to regular interval (optional)                                                                                                       | `false`                                                 |
| `policy`                               | Modify how DNS records are synchronized between sources and providers (options: sync, upsert-only )                                                                                                             | `upsert-only`                                           |
| `registry`                             | Registry method to use (options: txt, noop)                                                                                                                                                                     | `txt`                                                   |
| `txtOwnerId`                           | When using the TXT registry, a name that identifies this instance of ExternalDNS (optional)                                                                                                                     | `"default"`                                             |
| `txtPrefix`                            | When using the TXT registry, a prefix for ownership records that avoids collision with CNAME entries (optional)                                                                                                 | `""`                                                    |
| `extraArgs`                            | Extra arguments to be passed to external-dns                                                                                                                                                                    | `{}`                                                    |
| `extraEnv`                             | Extra environment variables to be passed to external-dns                                                                                                                                                        | `[]`                                                    |
| `replicas`                             | Desired number of ExternalDNS replicas                                                                                                                                                                          | `1`                                                     |
| `podAffinityPreset`                    | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                             | `""`                                                    |
| `podAntiAffinityPreset`                | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                        | `soft`                                                  |
| `nodeAffinityPreset.type`              | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                       | `""`                                                    |
| `nodeAffinityPreset.key`               | Node label key to match Ignored if `affinity` is set.                                                                                                                                                           | `""`                                                    |
| `nodeAffinityPreset.values`            | Node label values to match. Ignored if `affinity` is set.                                                                                                                                                       | `[]`                                                    |
| `affinity`                             | Affinity for pod assignment                                                                                                                                                                                     | `{}` (evaluated as a template)                          |
| `nodeSelector`                         | Node labels for pod assignment                                                                                                                                                                                  | `{}` (evaluated as a template)                          |
| `tolerations`                          | Tolerations for pod assignment                                                                                                                                                                                  | `[]` (evaluated as a template)                          |
| `podAnnotations`                       | Additional annotations to apply to the pod.                                                                                                                                                                     | `{}`                                                    |
| `podLabels`                            | Additional labels to be added to pods                                                                                                                                                                           | `{}`                                                    |
| `podSecurityContext.fsGroup`           | Group ID for the container                                                                                                                                                                                      | `1001`                                                  |
| `podSecurityContext.runAsUser`         | User ID for the container                                                                                                                                                                                       | `1001`                                                  |
| `priorityClassName`                    | priorityClassName                                                                                                                                                                                               | `""`                                                    |
| `secretAnnotations`                    | Additional annotations to apply to the secret                                                                                                                                                                   | `{}`                                                    |
| `securityContext`                      | Security context for the container                                                                                                                                                                              | `{}`                                                    |
| `podDisruptionBudget`                  | PodDisruptionBudget for the pod                                                                                                                                                                                 | `{}`                                                    |
| `service.enabled`                      | Whether to create Service resource or not                                                                                                                                                                       | `true`                                                  |
| `service.type`                         | Kubernetes Service type                                                                                                                                                                                         | `ClusterIP`                                             |
| `service.port`                         | ExternalDNS client port                                                                                                                                                                                         | `7979`                                                  |
| `service.nodePort`                     | Port to bind to for NodePort service type (client port)                                                                                                                                                         | `nil`                                                   |
| `service.clusterIP`                    | IP address to assign to service                                                                                                                                                                                 | `""`                                                    |
| `service.externalIPs`                  | Service external IP addresses                                                                                                                                                                                   | `[]`                                                    |
| `service.loadBalancerIP`               | IP address to assign to load balancer (if supported)                                                                                                                                                            | `""`                                                    |
| `service.loadBalancerSourceRanges`     | List of IP CIDRs allowed access to load balancer (if supported)                                                                                                                                                 | `[]`                                                    |
| `service.annotations`                  | Annotations to add to service                                                                                                                                                                                   | `{}`                                                    |
| `service.labels`                       | Labels to add to service                                                                                                                                                                                        | `{}`                                                    |
| `serviceAccount.create`                | Determine whether a Service Account should be created or it should reuse a exiting one.                                                                                                                         | `true`                                                  |
| `serviceAccount.name`                  | ServiceAccount to use. A name is generated using the external-dns.fullname template if it is not set                                                                                                            | `nil`                                                   |
| `serviceAccount.annotations`           | Additional Service Account annotations                                                                                                                                                                          | `{}`                                                    |
| `serviceAccount.automountServiceAccountToken` | Automount API credentials for a service account.                                                                                                                                         | `true`                                                  |
| `rbac.create`                          | Whether to create & use RBAC resources or not                                                                                                                                                                   | `true`                                                  |
| `rbac.apiVersion`                      | Version of the RBAC API                                                                                                                                                                                         | `v1`                                                    |
| `rbac.pspEnabled`                      | PodSecurityPolicy                                                                                                                                                                                               | `false`                                                 |
| `rbac.clusterRole`                     | Whether to create Cluster Role. When set to false creates a Role in `namespace`                                                                                                                                 | `true`                                                  |
| `resources`                            | CPU/Memory resource requests/limits.                                                                                                                                                                            | `{}`                                                    |
| `livenessProbe`                        | Deployment Liveness Probe                                                                                                                                                                                       | See `values.yaml`                                       |
| `readinessProbe`                       | Deployment Readiness Probe                                                                                                                                                                                      | See `values.yaml`                                       |
| `extraVolumes`                         | A list of volumes to be added to the pod                                                                                                                                                                        | `[]`                                                    |
| `extraVolumeMounts`                    | A list of volume mounts to be added to the pod                                                                                                                                                                  | `[]`                                                    |
| `metrics.enabled`                      | Enable prometheus to access external-dns metrics endpoint                                                                                                                                                       | `false`                                                 |
| `metrics.podAnnotations`               | Annotations for enabling prometheus to access the metrics endpoint                                                                                                                                              |                                                         |
| `metrics.serviceMonitor.enabled`       | Create ServiceMonitor object                                                                                                                                                                                    | `false`                                                 |
| `metrics.serviceMonitor.selector`      | Additional labels for ServiceMonitor object                                                                                                                                                                     | `{}`                                                    |
| `metrics.serviceMonitor.interval`      | Interval at which metrics should be scraped                                                                                                                                                                     | `30s`                                                   |
| `metrics.serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended                                                                                                                                                                         | `30s`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set provider=aws bitnami/external-dns
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml bitnami/external-dns
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Using IRSA
If you are deploying to AWS EKS and you want to leverage [IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html). You will need to override `fsGroup` and `runAsUser` with `65534`(nfsnobody) and `0` respectively. Otherwise service account token will not be properly mounted.
You can use the following arguments:
```
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
```bash
$ helm install my-release \
  --set provider=aws \
  --set aws.zoneType=public \
  --set txtOwnerId=HOSTED_ZONE_IDENTIFIER \
  --set domainFilters[0]=HOSTED_ZONE_NAME \
  bitnami/external-dns
```

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).

## Upgrading

### To 4.3.0

This version also introduces `bitnami/common`, a [library chart](https://helm.sh/docs/topics/library_charts/#helm) as a dependency. More documentation about this new utility could be found [here](https://github.com/bitnami/charts/tree/master/bitnami/common#bitnami-common-library-chart). Please, make sure that you have updated thechart dependencies before executing any upgrade.

### To 4.0.0

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

### To 3.0.0

- The parameters below are renamed:
  - `rbac.serviceAccountCreate` -> `serviceAccount.create`
  - `rbac.serviceAccountName` -> `serviceAccount.name`
  - `rbac.serviceAccountAnnotations` -> `serviceAccount.annotations`
- It is now possible to create serviceAccount, clusterRole and clusterRoleBinding manually and give the serviceAccount to the chart.

### 2.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is `my-release`:

```console
$ kubectl delete deployment my-release-external-dns
$ helm upgrade my-release bitnami/external-dns
```

Other mayor changes included in this major version are:

- Default image changes from `registry.opensource.zalan.do/teapot/external-dns` to `bitnami/external-dns`.
- The parameters below are renamed:
  - `aws.secretKey` -> `aws.credentials.secretKey`
  - `aws.accessKey` -> `aws.credentials.accessKey`
  - `aws.credentialsPath` -> `aws.credentials.mountPath`
  - `designate.customCA.directory` -> `designate.customCA.mountPath`
- Support to Prometheus metrics is added.
