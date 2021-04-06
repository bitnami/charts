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

{{/* Helm required labels */}}
{{- define "external-dns.labels" -}}
app.kubernetes.io/name: {{ template "external-dns.name" . }}
helm.sh/chart: {{ template "external-dns.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.podLabels }}
{{ toYaml .Values.podLabels }}
{{- end }}
{{- end -}}

{{/* matchLabels */}}
{{- define "external-dns.matchLabels" -}}
app.kubernetes.io/name: {{ template "external-dns.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
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
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
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
{{- if and (eq .Values.provider "alibabacloud") .Values.alibabacloud.accessKeyId .Values.alibabacloud.accessKeySecret (not .Values.alibabacloud.secretName) }}
    {{- true -}}
{{- else if and (eq .Values.provider "aws") .Values.aws.credentials.secretKey .Values.aws.credentials.accessKey (not .Values.aws.credentials.secretName) }}
    {{- true -}}
{{- else if and (eq .Values.provider "azure") (or (and .Values.azure.resourceGroup .Values.azure.tenantId .Values.azure.subscriptionId .Values.azure.aadClientId .Values.azure.aadClientSecret (not .Values.azure.useManagedIdentityExtension)) (and .Values.azure.resourceGroup .Values.azure.tenantId .Values.azure.subscriptionId .Values.azure.useManagedIdentityExtension)) (not .Values.azure.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "azure-private-dns") (or (and .Values.azure.aadClientId .Values.azure.aadClientSecret) (not .Values.azure.secretName)) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "cloudflare") (or .Values.cloudflare.apiToken .Values.cloudflare.apiKey) (not .Values.cloudflare.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "designate") (or .Values.designate.username .Values.designate.password) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "digitalocean") .Values.digitalocean.apiToken (not .Values.digitalocean.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "google") .Values.google.serviceAccountKey (not .Values.google.serviceAccountSecret) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "hetzner") .Values.hetzner.token (not .Values.hetzner.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "infoblox") (and .Values.infoblox.wapiUsername .Values.infoblox.wapiPassword) (not .Values.infoblox.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "linode") .Values.linode.apiToken (not .Values.linode.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "rfc2136") .Values.rfc2136.tsigSecret -}}
    {{- true -}}
{{- else if and (eq .Values.provider "pdns") .Values.pdns.apiKey (not .Values.pdns.secretName) -}}
    {{- true -}}
{{- else if and (eq .Values.provider "transip") .Values.transip.apiKey -}}
    {{- true -}}
{{- else if and (eq .Values.provider "ovh") .Values.ovh.consumerKey -}}
    {{- true -}}
{{- else if and (eq .Values.provider "scaleway") .Values.scaleway.scwAccessKey -}}
    {{- true -}}
{{- else if and (eq .Values.provider "vinyldns") (or .Values.vinyldns.secretKey .Values.vinyldns.accessKey) -}}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the Secret used to store the passwords
*/}}
{{- define "external-dns.secretName" -}}
{{- if and (eq .Values.provider "alibabacloud") .Values.alibabacloud.secretName }}
{{- .Values.alibabacloud.secretName }}
{{- else if and (eq .Values.provider "aws") .Values.aws.credentials.secretName }}
{{- .Values.aws.credentials.secretName }}
{{- else if and (or (eq .Values.provider "azure") (eq .Values.provider "azure-private-dns")) .Values.azure.secretName }}
{{- .Values.azure.secretName }}
{{- else if and (eq .Values.provider "cloudflare") .Values.cloudflare.secretName }}
{{- .Values.cloudflare.secretName }}
{{- else if and (eq .Values.provider "digitalocean") .Values.digitalocean.secretName }}
{{- .Values.digitalocean.secretName }}
{{- else if and (eq .Values.provider "google") .Values.google.serviceAccountSecret }}
{{- .Values.google.serviceAccountSecret }}
{{- else if and (eq .Values.provider "hetzner") .Values.hetzner.secretName -}}
{{- .Values.hetzner.secretName -}}
{{- else if and (eq .Values.provider "linode") .Values.linode.secretName }}
{{- .Values.linode.secretName }}
{{- else if and (eq .Values.provider "pdns") .Values.pdns.secretName }}
{{- .Values.pdns.secretName }}
{{- else if and (eq .Values.provider "infoblox") .Values.infoblox.secretName }}
{{- .Values.infoblox.secretName }}
{{- else -}}
{{- template "external-dns.fullname" . }}
{{- end -}}
{{- end -}}

{{- define "external-dns.alibabacloud-credentials" -}}
{
  {{- if .Values.alibabacloud.regionId }}
  "regionId": "{{ .Values.alibabacloud.regionId }}",
  {{- end}}
  {{- if .Values.alibabacloud.vpcId }}
  "vpcId": "{{ .Values.alibabacloud.vpcId }}",
  {{- end}}
  {{- if .Values.alibabacloud.accessKeyId }}
  "accessKeyId": "{{ .Values.alibabacloud.accessKeyId }}",
  {{- end}}
  {{- if .Values.alibabacloud.accessKeySecret }}
  "accessKeySecret": "{{ .Values.alibabacloud.accessKeySecret }}"
  {{- end}}
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

{{- define "external-dns.azure-credentials" -}}
{
  {{- if .Values.azure.cloud }}
  "cloud": "{{ .Values.azure.cloud }}",
  {{- end}}
  "tenantId": "{{ .Values.azure.tenantId }}",
  "subscriptionId": "{{ .Values.azure.subscriptionId }}",
  "resourceGroup": "{{ .Values.azure.resourceGroup }}",
  {{- if not .Values.azure.useManagedIdentityExtension }}
  "aadClientId": "{{ .Values.azure.aadClientId }}",
  "aadClientSecret": "{{ .Values.azure.aadClientSecret }}"
  {{- end }}
  {{- if and .Values.azure.useManagedIdentityExtension .Values.azure.userAssignedIdentityID }}
  "useManagedIdentityExtension": true,
  "userAssignedIdentityID": "{{ .Values.azure.userAssignedIdentityID }}"
  {{- else if and .Values.azure.useManagedIdentityExtension (not .Values.azure.userAssignedIdentityID) }}
  "useManagedIdentityExtension": true
  {{- end }}
}
{{ end }}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "external-dns.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "external-dns.validateValues.provider" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.sources" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.aws" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.infoblox.gridHost" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.infoblox.wapiPassword" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.pdns.apiUrl" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.pdns.apiKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.resourceGroupWithoutTenantId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.resourceGroupWithoutSubscriptionId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.tenantIdWithoutResourceGroup" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.tenantIdWithoutSubscriptionId" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.azure.subscriptionIdWithoutResourceGroup" .) -}}
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
{{- $messages := append $messages (include "external-dns.validateValues.linode.apiToken" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.ovh.consumerKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.ovh.applicationKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.ovh.applicationSecret" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.scaleway.scwAccessKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.scaleway.scwSecretKey" .) -}}
{{- $messages := append $messages (include "external-dns.validateValues.scaleway.scwDefaultOrganizationId" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
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
Return the appropriate apiVersion for PodSecurityPolicy.
*/}}
{{- define "podSecurityPolicy.apiVersion" -}}
{{- if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "policy/v1beta1" -}}
{{- else -}}
{{- print "extensions/v1beta1" -}}
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
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
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
- must provide the Azure Tenant ID when provider is "azure" and secretName is not set and resourceGroup is set
*/}}
{{- define "external-dns.validateValues.azure.tenantIdWithoutResourceGroup" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.tenantId) (not .Values.azure.secretName) .Values.azure.resourceGroup -}}
external-dns: azure.tenantId
    You must provide the Azure Tenant ID when provider="azure" and resourceGroup is set.
    Please set the tenantId parameter (--set azure.tenantId="xxxx")
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
- must provide the Azure Subscription ID when provider is "azure" and secretName is not set and resourceGroup is set
*/}}
{{- define "external-dns.validateValues.azure.subscriptionIdWithoutResourceGroup" -}}
{{- if and (eq .Values.provider "azure") (not .Values.azure.subscriptionId) (not .Values.azure.secretName) .Values.azure.resourceGroup -}}
external-dns: azure.subscriptionId
    You must provide the Azure Subscription ID when provider="azure" and resourceGroup is set.
    Please set the subscriptionId parameter (--set azure.subscriptionId="xxxx")
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
{{- if and (eq .Values.provider "azure") (not .Values.azure.secretName) (not .Values.azure.aadClientId) (not .Values.azure.useManagedIdentityExtension) .Values.azure.aadClientSecret -}}
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
{{- if and (eq .Values.provider "azure-private-dns") (not .Values.azure.secretName) (not .Values.azure.aadClientId) (not .Values.azure.useManagedIdentityExtension) (not .Values.azure.userAssignedIdentityID) -}}
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
{{- if and (eq .Values.provider "azure-private-dns") (not .Values.azure.secretName) (not .Values.azure.aadClientSecret) (not .Values.azure.useManagedIdentityExtension) (not .Values.azure.userAssignedIdentityID) -}}
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
- must provide the OVH consumer key when provider is "ovh"
*/}}
{{- define "external-dns.validateValues.ovh.consumerKey" -}}
{{- if and (eq .Values.provider "ovh") (not .Values.ovh.consumerKey) -}}
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
{{- if and (eq .Values.provider "ovh") (not .Values.ovh.applicationKey) -}}
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
{{- if and (eq .Values.provider "ovh") (not .Values.ovh.applicationSecret) -}}
external-dns: ovh.applicationSecret
    You must provide the OVH appliciation secret key when provider="ovh".
    Please set the applicationSecret parameter (--set ovh.applicationSecret="xxxx")
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
Validate values of External DNS:
- must provide the scaleway organization id when provider is "scaleway"
*/}}
{{- define "external-dns.validateValues.scaleway.scwDefaultOrganizationId" -}}
{{- if and (eq .Values.provider "scaleway") (not .Values.scaleway.scwDefaultOrganizationId) -}}
external-dns: scaleway.scwDefaultOrganizationId
    You must provide the scaleway organization id key when provider="scaleway".
    Please set the scwDefaultOrganizationId parameter (--set scaleway.scwDefaultOrganizationId="xxxx")
{{- end -}}
{{- end -}}

{/*
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
{{- else -}}
    {{ .Values.namespace }}
{{- end -}}
{{- end -}}
