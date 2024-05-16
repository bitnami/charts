{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "external-dns.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "external-dns.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "external-dns.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* podAnnotations */}}
{{- define "external-dns.podAnnotations" -}}
{{- if .Values.podAnnotations }}
{{ toYaml .Values.podAnnotations }}
{{- end }}
{{- if .Values.metrics.podAnnotations }}
{{ toYaml .Values.metrics.podAnnotations }}
{{- end }}
{{- end -}}

{{/*
Return the proper External DNS image name
*/}}
{{- define "external-dns.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "external-dns.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "external-dns.createSecret" -}}
{{- if and (eq .Values.provider "akamai") .Values.akamai.clientSecret (not .Values.akamai.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "alibabacloud") .Values.alibabacloud.accessKeyId .Values.alibabacloud.accessKeySecret (not .Values.alibabacloud.secretName) }}
    {{- true -}}
{{- else if and (eq .Values.provider "aws") .Values.aws.credentials.secretKey .Values.aws.credentials.accessKey (not .Values.aws.credentials.secretName) (not (include "external-dns.aws-credentials-secret-ref-defined" . )) }}
    {{- true -}}
{{- else if and (or (eq .Values.provider "azure") (eq .Values.provider "azure-private-dns")) (or (and .Values.azure.resourceGroup .Values.azure.tenantId .Values.azure.subscriptionId .Values.azure.aadClientId .Values.azure.aadClientSecret (not .Values.azure.useManagedIdentityExtension)) (and .Values.azure.resourceGroup .Values.azure.subscriptionId .Values.azure.useWorkloadIdentityExtension (not .Values.azure.useManagedIdentityExtension)) (and .Values.azure.resourceGroup .Values.azure.tenantId .Values.azure.subscriptionId .Values.azure.useManagedIdentityExtension)) (not .Values.azure.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "cloudflare") (or .Values.cloudflare.apiToken .Values.cloudflare.apiKey) (not .Values.cloudflare.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "designate") (or .Values.designate.username .Values.designate.password) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "designate") (or .Values.designate.applicationCredentialId .Values.designate.applicationCredentialSecret) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "digitalocean") .Values.digitalocean.apiToken (not .Values.digitalocean.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "exoscale") .Values.exoscale.apiKey (not .Values.exoscale.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "google") .Values.google.serviceAccountKey (not .Values.google.serviceAccountSecret) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "hetzner") .Values.hetzner.token (not .Values.hetzner.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "infoblox") (and .Values.infoblox.wapiUsername .Values.infoblox.wapiPassword) (not .Values.infoblox.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "linode") .Values.linode.apiToken (not .Values.linode.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "oci") .Values.oci.privateKeyFingerprint (not .Values.oci.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "rfc2136") (or .Values.rfc2136.tsigSecret (and .Values.rfc2136.kerberosUsername .Values.rfc2136.kerberosPassword)) (not .Values.rfc2136.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "pdns") .Values.pdns.apiKey (not .Values.pdns.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "transip") .Values.transip.apiKey -}}
    {{- true -}}
{{- else if and (eq .Values.provider "ovh") .Values.ovh.consumerKey (not .Values.ovh.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "scaleway") .Values.scaleway.scwAccessKey -}}
    {{- true -}}
{{- else if and (eq .Values.provider "vinyldns") (or .Values.vinyldns.secretKey .Values.vinyldns.accessKey) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "ns1") .Values.ns1.apiKey (not .Values.ns1.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "civo") .Values.civo.apiToken (not .Values.civo.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "pihole") .Values.pihole.secretName (not .Values.pihole.secretName) -}}
    {{- true -}}
{{- else if and .Values.txtEncrypt.enabled (not .Values.txtEncrypt.secretName) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "external-dns.createConfigMap" -}}
{{- if and (eq .Values.provider "designate") .Values.designate.customCA.enabled }}
    {{- true -}}
{{- else if and (eq .Values.provider "rfc2136") .Values.rfc2136.rfc3645Enabled }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the Secret used to store the passwords
*/}}
{{- define "external-dns.secretName" -}}
{{- if and (eq .Values.provider "akamai") .Values.akamai.secretName }}
{{- .Values.akamai.secretName }}
{{- else if and (eq .Values.provider "alibabacloud") .Values.alibabacloud.secretName }}
{{- .Values.alibabacloud.secretName }}
{{- else if and (eq .Values.provider "aws") .Values.aws.credentials.secretName }}
{{- .Values.aws.credentials.secretName }}
{{- else if and (or (eq .Values.provider "azure") (eq .Values.provider "azure-private-dns")) .Values.azure.secretName }}
{{- .Values.azure.secretName }}
{{- else if and (eq .Values.provider "cloudflare") .Values.cloudflare.secretName }}
{{- .Values.cloudflare.secretName }}
{{- else if and (eq .Values.provider "digitalocean") .Values.digitalocean.secretName }}
{{- .Values.digitalocean.secretName }}
{{- else if and (eq .Values.provider "exoscale") .Values.exoscale.secretName }}
{{- .Values.exoscale.secretName }}
{{- else if and (eq .Values.provider "google") .Values.google.serviceAccountSecret }}
{{- .Values.google.serviceAccountSecret }}
{{- else if and (eq .Values.provider "hetzner") .Values.hetzner.secretName }}
{{- .Values.hetzner.secretName }}
{{- else if and (eq .Values.provider "linode") .Values.linode.secretName }}
{{- .Values.linode.secretName }}
{{- else if and (eq .Values.provider "oci") .Values.oci.secretName }}
{{- .Values.oci.secretName }}
{{- else if and (eq .Values.provider "ovh") .Values.ovh.secretName }}
{{- .Values.ovh.secretName }}
{{- else if and (eq .Values.provider "pdns") .Values.pdns.secretName }}
{{- .Values.pdns.secretName }}
{{- else if and (eq .Values.provider "infoblox") .Values.infoblox.secretName }}
{{- .Values.infoblox.secretName }}
{{- else if and (eq .Values.provider "rfc2136") .Values.rfc2136.secretName }}
{{- .Values.rfc2136.secretName }}
{{- else if and (eq .Values.provider "ns1") .Values.ns1.secretName }}
{{- .Values.ns1.secretName }}
{{- else if and (eq .Values.provider "civo") .Values.civo.secretName }}
{{- .Values.civo.secretName }}
{{- else if and (eq .Values.provider "pihole") .Values.pihole.secretName }}
{{- .Values.pihole.secretName }}
{{- else -}}
{{- template "external-dns.fullname" . }}
{{- end -}}
{{- end -}}

{{- define "external-dns.alibabacloud-credentials" -}}
{
  {{- if .Values.alibabacloud.regionId }}
  "regionId": "{{ .Values.alibabacloud.regionId }}",
  {{- end }}
  {{- if .Values.alibabacloud.vpcId }}
  "vpcId": "{{ .Values.alibabacloud.vpcId }}",
  {{- end }}
  {{- if .Values.alibabacloud.accessKeyId }}
  "accessKeyId": "{{ .Values.alibabacloud.accessKeyId }}",
  {{- end }}
  {{- if .Values.alibabacloud.accessKeySecret }}
  "accessKeySecret": "{{ .Values.alibabacloud.accessKeySecret }}"
  {{- end }}
}
{{ end }}

{{- define "external-dns.aws-credentials" }}
[default]
aws_access_key_id = {{ .Values.aws.credentials.accessKey }}
aws_secret_access_key = {{ .Values.aws.credentials.secretKey }}
{{ end }}

{{- define "external-dns.aws-config" }}
[profile default]
region = {{ .Values.aws.region }}
{{ end }}

{{- define "external-dns.aws-credentials-secret-ref-defined" -}}
{{- if and .Values.aws.credentials.accessKeyIDSecretRef.name .Values.aws.credentials.accessKeyIDSecretRef.key .Values.aws.credentials.secretAccessKeySecretRef.name .Values.aws.credentials.secretAccessKeySecretRef.key -}}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{- define "external-dns.azure-credentials" -}}
{
  {{- if .Values.azure.cloud }}
  "cloud": "{{ .Values.azure.cloud }}",
  {{- end }}
  {{- if .Values.azure.tenantId }}
  "tenantId": "{{ .Values.azure.tenantId }}",
  {{- end }}
  {{- if .Values.azure.subscriptionId }}
  "subscriptionId": "{{ .Values.azure.subscriptionId }}",
  {{- end }}
  "resourceGroup": "{{ .Values.azure.resourceGroup }}",
  {{- if not (or .Values.azure.useManagedIdentityExtension .Values.azure.useWorkloadIdentityExtension) }}
  "aadClientId": "{{ .Values.azure.aadClientId }}",
  "aadClientSecret": "{{ .Values.azure.aadClientSecret }}"
  {{- end }}
  {{- if .Values.azure.useWorkloadIdentityExtension }}
  "useWorkloadIdentityExtension":  true,
  {{- end }}
  {{- if and .Values.azure.useManagedIdentityExtension .Values.azure.userAssignedIdentityID }}
  "useManagedIdentityExtension": true,
  "userAssignedIdentityID": "{{ .Values.azure.userAssignedIdentityID }}"
  {{- else if and .Values.azure.useManagedIdentityExtension (not .Values.azure.userAssignedIdentityID) }}
  "useManagedIdentityExtension": true
  {{- end }}
}
{{ end }}
{{- define "external-dns.oci-credentials" -}}
{{- if .Values.oci.useWorkloadIdentity }}
auth:
  region: {{ .Values.oci.region }}
  useWorkloadIdentity: true
compartment: {{ .Values.oci.compartmentOCID }}
{{- else }}
auth:
  region: {{ .Values.oci.region }}
  tenancy: {{ .Values.oci.tenancyOCID }}
  user: {{ .Values.oci.userOCID }}
  key: {{ toYaml .Values.oci.privateKey | indent 4 }}
  fingerprint: {{ .Values.oci.privateKeyFingerprint }}
  # Omit if there is not a password for the key
  {{- if .Values.oci.privateKeyPassphrase }}
  passphrase: {{ .Values.oci.privateKeyPassphrase }}
  {{- end }}
compartment: {{ .Values.oci.compartmentOCID }}
{{- end }}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail if the validation is enabled
*/}}
{{- define "external-dns.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "external-dns.validateValues.provider" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.sources" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.akamai.host" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.akamai.accessToken" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.akamai.clientToken" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.akamai.clientSecret" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.aws" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.infoblox.gridHost" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.infoblox.wapiPassword" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.pdns.apiUrl" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.pdns.apiKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.resourceGroupWithoutTenantId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.resourceGroupWithoutSubscriptionId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.tenantIdWithoutSubscriptionId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.subscriptionIdWithoutTenantId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.useManagedIdentityExtensionAadClientId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.useManagedIdentityExtensionAadClientSecret" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.userAssignedIdentityIDWithoutUseManagedIdentityExtension" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.aadClientId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.aadClientSecret" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azurePrivateDns.resourceGroup" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azurePrivateDns.tenantId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azurePrivateDns.subscriptionId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azurePrivateDns.aadClientId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azurePrivateDns.aadClientSecret" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azurePrivateDns.useManagedIdentityExtensionAadClientId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azurePrivateDns.useManagedIdentityExtensionAadClientSecret" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azurePrivateDns.userAssignedIdentityIDWithoutUseManagedIdentityExtension" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.transip.account" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.transip.apiKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.ns1.apiKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.linode.apiToken" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.ovh.consumerKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.ovh.applicationKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.ovh.applicationSecret" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.rfc2136.kerberosRealm" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.rfc2136.kerberosConfig" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.scaleway.scwAccessKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.scaleway.scwSecretKey" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if .Values.validation.enabled -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must set a provider
*/}}
{{- define "external-dns.validateValues.provider" -}}
{{- if not .Values.provider -}}
external-dns: provider
    You must set a provider (options: aws, google, azure, cloudflare, ...)
    Please set the provider parameter (--set provider="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide sources to be observed for new DNS entries by ExternalDNS
*/}}
{{- define "external-dns.validateValues.sources" -}}
{{- if empty .Values.sources -}}
external-dns: sources
    You must provide sources to be observed for new DNS entries by ExternalDNS
    Please set the sources parameter (--set sources="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the Akamai host when provider is "akamai"
*/}}
{{- define "external-dns.validateValues.akamai.host" -}}
{{- if and (eq .Values.provider "akamai") (not .Values.akamai.host) -}}
external-dns: akamai.host
    You must provide the Akamai host when provider="akamai".
    Please set the host parameter (--set akamai.host="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the Akamai access token when provider is "akamai"
*/}}
{{- define "external-dns.validateValues.akamai.accessToken" -}}
{{- if and (eq .Values.provider "akamai") (not .Values.akamai.accessToken) -}}
external-dns: akamai.accessToken
    You must provide the Akamai access token when provider="akamai".
    Please set the accessToken parameter (--set akamai.accessToken="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the Akamai client token when provider is "akamai"
*/}}
{{- define "external-dns.validateValues.akamai.clientToken" -}}
{{- if and (eq .Values.provider "akamai") (not .Values.akamai.clientToken) -}}
external-dns: akamai.clientToken
    You must provide the Akamai client token when provider="akamai".
    Please set the clientToken parameter (--set akamai.clientToken="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the Akamai client secret when provider is "akamai"
*/}}
{{- define "external-dns.validateValues.akamai.clientSecret" -}}
{{- if and (eq .Values.provider "akamai") (not .Values.akamai.clientSecret) (not .Values.akamai.secretName) -}}
external-dns: akamai.clientSecret
    You must provide the Akamai client secret when provider="akamai".
    Please set the clientSecret parameter (--set akamai.clientSecret="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- The AWS Role to assume must follow ARN format when provider is "aws"
*/}}
{{- define "external-dns.validateValues.aws" -}}
{{- if and (eq .Values.provider "aws") .Values.aws.assumeRoleArn -}}
{{- if not (regexMatch "^arn:(aws|aws-us-gov|aws-cn):iam::.*$" .Values.aws.assumeRoleArn) -}}
external-dns: aws.assumeRoleArn
    The AWS Role to assume must follow ARN format: `arn:aws:iam::123455567:role/external-dns`
    Ref: https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html
    Please set a valid ARN (--set aws.assumeRoleARN="xxxx")
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the Grid Manager host when provider is "infoblox"
*/}}
{{- define "external-dns.validateValues.infoblox.gridHost" -}}
{{- if and (eq .Values.provider "infoblox") (not .Values.infoblox.gridHost) -}}
external-dns: infoblox.gridHost
    You must provide the Grid Manager host when provider="infoblox".
    Please set the gridHost parameter (--set infoblox.gridHost="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide a WAPI password when provider is "infoblox"
*/}}
{{- define "external-dns.validateValues.infoblox.wapiPassword" -}}
{{- if and (eq .Values.provider "infoblox") (not .Values.infoblox.wapiPassword) (not .Values.infoblox.secretName) -}}
external-dns: infoblox.wapiPassword
    You must provide a WAPI password when provider="infoblox".
    Please set the wapiPassword parameter (--set infoblox.wapiPassword="xxxx")
    or you can provide an existing secret name via infoblox.secretName
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the PowerDNS API URL when provider is "pdns"
*/}}
{{- define "external-dns.validateValues.pdns.apiUrl" -}}
{{- if and (eq .Values.provider "pdns") (not .Values.pdns.apiUrl) -}}
external-dns: pdns.apiUrl
    You must provide the PowerDNS API URL when provider="pdns".
    Please set the apiUrl parameter (--set pdns.apiUrl="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the PowerDNS API key when provider is "pdns"
*/}}
{{- define "external-dns.validateValues.pdns.apiKey" -}}
{{- if and (eq .Values.provider "pdns") (not .Values.pdns.apiKey) (not .Values.pdns.secretName) -}}
external-dns: pdns.apiKey
    You must provide the PowerDNS API key when provider="pdns".
    Please set the apiKey parameter (--set pdns.apiKey="xxxx")
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "external-dns.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image.repository) (not (.Values.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image.repository }}:{{ .Values.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/services/tutorials/GUID-understand-rolling-tags-containers-index.html
{{- end }}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must provide the Azure Resource Group when provider is "azure" and tenantId is set
*/}}
{{- define "external-dns.validateValues.azure.resourceGroupWithoutTenantId" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.resourceGroup) (not .Values.azure.secretName) .Values.azure.tenantId -}}
external-dns: azure.resourceGroup
    You must provide the Azure Resource Group when provider="azure" and tenantId is set.
    Please set the resourceGroup parameter (--set azure.resourceGroup="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must provide the Azure Resource Group when provider is "azure" and subscriptionId is set
*/}}
{{- define "external-dns.validateValues.azure.resourceGroupWithoutSubscriptionId" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.resourceGroup) (not .Values.azure.secretName) .Values.azure.subscriptionId -}}
external-dns: azure.resourceGroup
    You must provide the Azure Resource Group when provider="azure" and subscriptionId is set.
    Please set the resourceGroup parameter (--set azure.resourceGroup="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must provide the Azure Tenant ID when provider is "azure" and secretName is not set and subscriptionId is set
*/}}
{{- define "external-dns.validateValues.azure.tenantIdWithoutSubscriptionId" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.tenantId) (not .Values.azure.secretName) .Values.azure.subscriptionId -}}
external-dns: azure.tenantId
    You must provide the Azure Tenant ID when provider="azure" and subscriptionId is set.
    Please set the tenantId parameter (--set azure.tenantId="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must provide the Azure Subscription ID when provider is "azure" and secretName is not set and tenantId is set
*/}}
{{- define "external-dns.validateValues.azure.subscriptionIdWithoutTenantId" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.subscriptionId) (not .Values.azure.secretName) .Values.azure.tenantId -}}
external-dns: azure.subscriptionId
    You must provide the Azure Subscription ID when provider="azure" and tenantId is set.
    Please set the subscriptionId parameter (--set azure.subscriptionId="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must not provide the Azure AAD Client ID when provider is "azure", secretName is not set and MSI is enabled
*/}}
{{- define "external-dns.validateValues.azure.useManagedIdentityExtensionAadClientId" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.secretName) .Values.azure.aadClientId .Values.azure.useManagedIdentityExtension -}}
external-dns: azure.useManagedIdentityExtension
    You must not provide the Azure AAD Client ID when provider="azure" and useManagedIdentityExtension is "true".
    Please unset the aadClientId parameter (--set azure.aadClientId="")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must not provide the Azure AAD Client secret when provider is "azure", secretName is not set and MSI is enabled
*/}}
{{- define "external-dns.validateValues.azure.useManagedIdentityExtensionAadClientSecret" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.secretName) .Values.azure.aadClientSecret .Values.azure.useManagedIdentityExtension -}}
external-dns: azure.useManagedIdentityExtension
    You must not provide the Azure AAD Client Secret when provider="azure" and useManagedIdentityExtension is "true".
    Please unset the aadClientSecret parameter (--set azure.aadClientSecret="")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must enable the MSI when provider is "azure", secretName is not set and managed identity ID is set
*/}}
{{- define "external-dns.validateValues.azure.userAssignedIdentityIDWithoutUseManagedIdentityExtension" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.secretName) (not .Values.azure.useManagedIdentityExtension) .Values.azure.userAssignedIdentityID -}}
external-dns: azure.userAssignedIdentityID
    You must enable the MSI when provider="azure" and userAssignedIdentityID is set.
    Please set the useManagedIdentityExtension parameter (--set azure.useManagedIdentityExtension="true")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must provide the Azure AAD Client ID when provider is "azure", secretName is not set and MSI is disabled and aadClientSecret is set
*/}}
{{- define "external-dns.validateValues.azure.aadClientId" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.secretName) (not .Values.azure.aadClientId) (not .Values.azure.useWorkloadIdentityExtension) (not .Values.azure.useManagedIdentityExtension) .Values.azure.aadClientSecret -}}
external-dns: azure.aadClientId
    You must provide the Azure AAD Client ID when provider="azure" and aadClientSecret is set and useManagedIdentityExtension is not set.
    Please set the aadClientId parameter (--set azure.aadClientId="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure DNS:
- must provide the Azure AAD Client Secret when provider is "azure", secretName is not set and MSI is disabled and aadClientId is set
*/}}
{{- define "external-dns.validateValues.azure.aadClientSecret" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.secretName) (not .Values.azure.aadClientSecret) (not .Values.azure.useManagedIdentityExtension) .Values.azure.aadClientId -}}
external-dns: azure.aadClientSecret
    You must provide the Azure AAD Client Secret when provider="azure" and aadClientId is set and useManagedIdentityExtension is not set.
    Please set the aadClientSecret parameter (--set azure.aadClientSecret="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure Private DNS:
- must provide the Azure AAD Client Secret when provider is "azure-private-dns", secretName is not set and useManagedIdentityExtension is "true"
*/}}
{{- define "external-dns.validateValues.azurePrivateDns.useManagedIdentityExtensionAadClientSecret" -}}
{{- if and (eq .Values.provider "azure-private-dns") (not .Values.azure.secretName) .Values.azure.aadClientSecret .Values.azure.useManagedIdentityExtension -}}
external-dns: azure.useManagedIdentityExtension
    You must not provide the Azure AAD Client Secret when provider="azure-private-dns", secretName is not set, and useManagedIdentityExtension is "true".
    Please unset the aadClientSecret parameter (--set azure.aadClientSecret="")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure Private DNS:
- must enable the MSI when provider is "azure", secretName is not set and managed identity ID is set
*/}}
{{- define "external-dns.validateValues.azurePrivateDns.userAssignedIdentityIDWithoutUseManagedIdentityExtension" -}}
{{- if and (eq .Values.provider "azure-private-dns") (not .Values.azure.secretName) (not .Values.azure.useManagedIdentityExtension) .Values.azure.userAssignedIdentityID -}}
external-dns: azure.userAssignedIdentityID
    You must enable the MSI when provider="azure-private-dns" and userAssignedIdentityID is set.
    Please set the useManagedIdentityExtension parameter (--set azure.useManagedIdentityExtension="true")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure Private DNS:
- must provide the Azure Resource Group when provider is "azure-private-dns"
- azure-private-dns provider does not use azure.json for specifying the resource group so it must be set
*/}}
{{- define "external-dns.validateValues.azurePrivateDns.resourceGroup" -}}
{{- if and (eq .Values.provider "azure-private-dns") (not .Values.azure.resourceGroup) -}}
external-dns: azure.resourceGroup
    You must provide the Azure Resource Group when provider="azure-private-dns".
    Please set the resourceGroup parameter (--set azure.resourceGroup="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure Private DNS:
- must provide the Azure Tenant ID when provider is "azure-private-dns"
*/}}
{{- define "external-dns.validateValues.azurePrivateDns.tenantId" -}}
{{- if and (eq .Values.provider "azure-private-dns") (not .Values.azure.tenantId) -}}
external-dns: azure.tenantId
    You must provide the Azure Tenant ID when provider="azure-private-dns".
    Please set the tenantId parameter (--set azure.tenantId="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure Private DNS:
- must provide the Azure Subscription ID when provider is "azure-private-dns"
*/}}
{{- define "external-dns.validateValues.azurePrivateDns.subscriptionId" -}}
{{- if and (eq .Values.provider "azure-private-dns") (not .Values.azure.subscriptionId) -}}
external-dns: azure.subscriptionId
    You must provide the Azure Subscription ID when provider="azure-private-dns".
    Please set the subscriptionId parameter (--set azure.subscriptionId="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure Private DNS:
- must not provide the Azure AAD Client Secret when provider is "azure-private-dns", secretName is not set and MSI is enabled
*/}}
{{- define "external-dns.validateValues.azurePrivateDns.useManagedIdentityExtensionAadClientId" -}}
{{- if and (eq .Values.provider "azure-private-dns") (not .Values.azure.secretName) .Values.azure.aadClientId .Values.azure.useManagedIdentityExtension -}}
external-dns: azure.useManagedIdentityExtension
    You must not provide the Azure AAD Client ID when provider="azure-private-dns" and useManagedIdentityExtension is "true".
    Please unset the aadClientId parameter (--set azure.aadClientId="")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure Private DNS:
- must provide the Azure AAD Client ID when provider is "azure-private-dns", secret name is not set and MSI is disabled
*/}}
{{- define "external-dns.validateValues.azurePrivateDns.aadClientId" -}}
{{- if and (eq .Values.provider "azure-private-dns") (not .Values.azure.secretName) (not .Values.azure.aadClientId) (not .Values.azure.useManagedIdentityExtension) (not .Values.azure.useWorkloadIdentityExtension) (not .Values.azure.userAssignedIdentityID) -}}
external-dns: azure.useManagedIdentityExtension
    You must provide the Azure AAD Client ID when provider="azure-private-dns" and useManagedIdentityExtension is not set.
    Please set the aadClientSecret parameter (--set azure.aadClientId="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of Azure Private DNS:
- must provide the Azure AAD Client Secret when provider is "azure-private-dns", secretName is not set and MSI is disabled
*/}}
{{- define "external-dns.validateValues.azurePrivateDns.aadClientSecret" -}}
{{- if and (eq .Values.provider "azure-private-dns") (not .Values.azure.secretName) (not .Values.azure.aadClientSecret) (not .Values.azure.useManagedIdentityExtension) (not .Values.azure.useWorkloadIdentityExtension) (not .Values.azure.userAssignedIdentityID) -}}
external-dns: azure.useManagedIdentityExtension
    You must provide the Azure AAD Client Secret when provider="azure-private-dns" and useManagedIdentityExtension is not set.
    Please set the aadClientSecret parameter (--set azure.aadClientSecret="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of TransIP DNS:
- must provide the account name when provider is "transip"
*/}}
{{- define "external-dns.validateValues.transip.account" -}}
{{- if and (eq .Values.provider "transip") (not .Values.transip.account) -}}
external-dns: transip.account
    You must provide the TransIP account name when provider="transip".
    Please set the account parameter (--set transip.account="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide an API token when provider is "hetzner"
*/}}
{{- define "external-dns.validateValues.hetzner" -}}
{{- if and (eq .Values.provider "hetzner") (or (not .Values.hetzner.token) (not .Values.hetzner.secretName)) -}}
external-dns: hetzner.token
    You must provide the a Hetzner API Token when provider="hetzner".
    Please set the token parameter (--set hetzner.token="xxxx")
    or specify a secret that contains an API token. (--set hetzner.secretName="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of TransIP DNS:
- must provide the API key when provider is "transip"
*/}}
{{- define "external-dns.validateValues.transip.apiKey" -}}
{{- if and (eq .Values.provider "transip") (not .Values.transip.apiKey) -}}
external-dns: transip.apiKey
    You must provide the TransIP API key when provider="transip".
    Please set the apiKey parameter (--set transip.apiKey="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the Linode API token when provider is "linode"
*/}}
{{- define "external-dns.validateValues.linode.apiToken" -}}
{{- if and (eq .Values.provider "linode") (not .Values.linode.apiToken) (not .Values.linode.secretName) -}}
external-dns: linode.apiToken
    You must provide the Linode API token when provider="linode".
    Please set the apiToken parameter (--set linode.apiToken="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the NS1 API key when provider is "ns1"
*/}}
{{- define "external-dns.validateValues.ns1.apiKey" -}}
{{- if and (eq .Values.provider "ns1") (not .Values.ns1.apiKey) (not .Values.ns1.secretName) -}}
external-dns: ns1.apiKey
    You must provide the NS1 API key when provider="ns1".
    Please set the token parameter (--set ns1.apiKey="xxxx")
    or specify a secret that contains an API key. (--set ns1.secretName="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the OVH consumer key when provider is "ovh"
*/}}
{{- define "external-dns.validateValues.ovh.consumerKey" -}}
{{- if and (eq .Values.provider "ovh") (not .Values.ovh.consumerKey) (not .Values.ovh.secretName) -}}
external-dns: ovh.consumerKey
    You must provide the OVH consumer key when provider="ovh".
    Please set the consumerKey parameter (--set ovh.consumerKey="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the OVH application key when provider is "ovh"
*/}}
{{- define "external-dns.validateValues.ovh.applicationKey" -}}
{{- if and (eq .Values.provider "ovh") (not .Values.ovh.applicationKey) (not .Values.ovh.secretName) -}}
external-dns: ovh.applicationKey
    You must provide the OVH appliciation key when provider="ovh".
    Please set the applicationKey parameter (--set ovh.applicationKey="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the OVH application secret when provider is "ovh"
*/}}
{{- define "external-dns.validateValues.ovh.applicationSecret" -}}
{{- if and (eq .Values.provider "ovh") (not .Values.ovh.applicationSecret) (not .Values.ovh.secretName) -}}
external-dns: ovh.applicationSecret
    You must provide the OVH appliciation secret key when provider="ovh".
    Please set the applicationSecret parameter (--set ovh.applicationSecret="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of RFC2136 DNS:
- Must provide the kerberos realm when provider is rfc2136 and rfc3645Enabled is true
*/}}
{{- define "external-dns.validateValues.rfc2136.kerberosRealm" -}}
{{- if and (eq .Values.provider "rfc2136") .Values.rfc2136.rfc3645Enabled (not .Values.rfc2136.kerberosRealm) -}}
external-dns: rfc2136.kerberosRealm
    You must provide the kerberos realm when provider is rfc2136 and rfc3645Enabled is true
    Please set the kerberosRealm parameter (--set rfc2136.kerberosRealm="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of RFC2136 DNS:
- Must provide the kerberos config when provider is rfc2136 and rfc3645Enabled is true
*/}}
{{- define "external-dns.validateValues.rfc2136.kerberosConfig" -}}
{{- if and (eq .Values.provider "rfc2136") .Values.rfc2136.rfc3645Enabled (not .Values.rfc2136.kerberosConfig) -}}
external-dns: rfc2136.kerberosConfig
    You must provide the kerberos config when provider is rfc2136 and rfc3645Enabled is true
    Please set the kerberosConfig parameter (--set-file rfc2136.kerberosConfig="path/to/krb5.conf")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the Scaleway access key when provider is "scaleway"
*/}}
{{- define "external-dns.validateValues.scaleway.scwAccessKey" -}}
{{- if and (eq .Values.provider "scaleway") (not .Values.scaleway.scwAccessKey) -}}
external-dns: scaleway.scwAccessKey
    You must provide the Scaleway access key when provider="scaleway".
    Please set the scwAccessKey parameter (--set scaleway.scwAccessKey="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of External DNS:
- must provide the scaleway secret key when provider is "scaleway"
*/}}
{{- define "external-dns.validateValues.scaleway.scwSecretKey" -}}
{{- if and (eq .Values.provider "scaleway") (not .Values.scaleway.scwSecretKey) -}}
external-dns: scaleway.scwSecretKey
    You must provide the scaleway secret key when provider="scaleway".
    Please set the scwSecretKey parameter (--set scaleway.scwSecretKey="xxxx")
{{- end -}}
{{- end -}}

{{/*
Return the ExternalDNS service account name
*/}}
{{- define "external-dns.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "external-dns.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the ExternalDNS namespace to be used
*/}}
{{- define "external-dns.namespace" -}}
{{- if and .Values.rbac.create (not .Values.rbac.clusterRole) -}}
    {{ default .Release.Namespace .Values.namespace }}
{{- else if .Values.watchReleaseNamespace -}}
    {{ .Release.namespace }}
{{- else -}}
    {{ .Values.namespace }}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing external-dns TLS certificates
*/}}
{{- define "external-dns.tlsSecretName" -}}
{{- if .Values.coredns.etcdTLS.autoGenerated -}}
    {{- printf "%s-crt" (include "external-dns.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $secretName := .Values.coredns.etcdTLS.secretName -}}
{{- printf "%s" (tpl $secretName $) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "external-dns.tlsCACert" -}}
{{- if .Values.coredns.etcdTLS.autoGenerated }}
    {{- printf "ca.crt" -}}
{{- else -}}
    {{- printf "%s" .Values.coredns.etcdTLS.caFilename -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert file.
*/}}
{{- define "external-dns.tlsCert" -}}
{{- if .Values.coredns.etcdTLS.autoGenerated }}
    {{- printf "tls.crt" -}}
{{- else -}}
    {{- printf "%s" .Values.coredns.etcdTLS.certFilename -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert key file.
*/}}
{{- define "external-dns.tlsCertKey" -}}
{{- if .Values.coredns.etcdTLS.autoGenerated }}
    {{- printf "tls.key" -}}
{{- else -}}
    {{- printf "%s" .Values.coredns.etcdTLS.keyFilename -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret object should be created
*/}}
{{- define "external-dns.createTlsSecret" -}}
{{- if and .Values.coredns.etcdTLS.enabled .Values.coredns.etcdTLS.autoGenerated }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns the name of the default secret if the AES key is set via `.Values.txtEncrypt.aesKey` and the name of the custom secret when `.Values.txtEncrypt.secretName` is used.
*/}}
{{- define "external-dns.txtEncryptKeySecretName" -}}
{{- if and .Values.txtEncrypt.enabled .Values.txtEncrypt.secretName }}
    {{- printf "%s" .Values.txtEncrypt.secretName -}}
{{- else if and .Values.txtEncrypt.enabled (not .Values.txtEncrypt.secretName) -}}
    {{ template "external-dns.secretName" . }}
{{- end -}}
{{- end -}}
