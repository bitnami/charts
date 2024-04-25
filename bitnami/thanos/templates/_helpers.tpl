{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Fully qualified app name for PostgreSQL
*/}}
{{- define "thanos.minio.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-minio" .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-minio" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-minio" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Thanos bucketweb fullname
*/}}
{{- define "thanos.bucketweb.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "bucketweb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Thanos compactor fullname
*/}}
{{- define "thanos.compactor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "compactor" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Thanos query-frontend fullname
*/}}
{{- define "thanos.query-frontend.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-frontend" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Thanos query fullname
*/}}
{{- define "thanos.query.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Thanos receive-distributor fullname
*/}}
{{- define "thanos.receive-distributor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "receive-distributor" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Thanos receive fullname
*/}}
{{- define "thanos.receive.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "receive" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Thanos compactor fullname
*/}}
{{- define "thanos.ruler.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "ruler" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Thanos storegateway fullname
*/}}
{{- define "thanos.storegateway.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "storegateway" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Thanos image name
*/}}
{{- define "thanos.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper init container volume-permissions image name
*/}}
{{- define "thanos.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "thanos.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the Thanos Objstore configuration secret.
*/}}
{{- define "thanos.objstoreSecretName" -}}
{{- if .Values.existingObjstoreSecret -}}
    {{- printf "%s" (tpl .Values.existingObjstoreSecret $) -}}
{{- else -}}
    {{- printf "%s-objstore-secret" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "thanos.createObjstoreSecret" -}}
{{- if and .Values.objstoreConfig (not .Values.existingObjstoreSecret) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the object store config
*/}}
{{- define "thanos.objstoreConfig" -}}
{{- if and .Values.objstoreConfig (not .Values.existingObjstoreSecret) }}
objstore.yml: |-
  {{- include "common.tplvalues.render" (dict "value" .Values.objstoreConfig "context" $) | b64enc | nindent 2 }}
{{- end }}
{{- end -}}

{{/*
Return the storegateway config
*/}}
{{- define "thanos.storegatewayConfigMap" -}}
{{- if .Values.storegateway.config }}
config.yml: |-
  {{- include "common.tplvalues.render" (dict "value" .Values.storegateway.config "context" $) | nindent 2 }}
{{- end }}
{{- if .Values.indexCacheConfig }}
index-cache.yml: |-
  {{- include "common.tplvalues.render" (dict "value" .Values.indexCacheConfig "context" $) | nindent 2 }}
{{- end }}
{{- if .Values.bucketCacheConfig }}
bucket-cache.yml: |-
  {{- include "common.tplvalues.render" (dict "value" .Values.bucketCacheConfig "context" $) | nindent 2 }}
{{- end }}
{{- end -}}

{{/*
Return the ruler config
*/}}
{{- define "thanos.rulerConfigMap" -}}
{{- if and .Values.ruler.config (not .Values.ruler.existingConfigmap) }}
ruler.yml: |-
  {{- include "common.tplvalues.render" (dict "value" .Values.ruler.config "context" $) | nindent 2 }}
{{- end }}
{{- end -}}

{{/*
Return the receive config
*/}}
{{- define "thanos.receiveConfigMap" -}}
hashrings.json: |-
  {{- include "common.tplvalues.render" (dict "value" (include "thanos.receive.config" .) "context" .) | nindent 2 }}
{{- end -}}

{{/*
Return the query config
*/}}
{{- define "thanos.querySDConfigMap" -}}
{{- if and .Values.query.sdConfig (not .Values.query.existingSDConfigmap) }}
servicediscovery.yml: |-
  {{- include "common.tplvalues.render" (dict "value" .Values.query.sdConfig "context" $) | nindent 2 }}
{{- end }}
{{- end -}}

{{/*
Return the query frontend config
*/}}
{{- define "thanos.queryFrontendConfigMap" -}}
{{- if and .Values.queryFrontend.config (not .Values.queryFrontend.existingConfigmap) }}
config.yml: |-
  {{- include "common.tplvalues.render" (dict "value" .Values.queryFrontend.config "context" $) | nindent 2 }}
{{- end }}
{{- end -}}

{{/*
Return the Thanos HTTPS and basic auth configuration secret.
*/}}
{{- define "thanos.httpConfigEnabled" -}}
{{- if or .Values.existingHttpConfigSecret .Values.https.enabled .Values.auth.basicAuthUsers .Values.httpConfig }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Thanos HTTPS and basic auth configuration secret.
*/}}
{{- define "thanos.httpCertsSecretName" -}}
{{- if .Values.https.existingSecret -}}
    {{- printf "%s" (tpl .Values.https.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-http-certs-secret" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Thanos HTTPS and basic auth configuration secret.
*/}}
{{- define "thanos.httpConfigSecretName" -}}
{{- if .Values.existingHttpConfigSecret -}}
    {{- printf "%s" (tpl .Values.existingHttpConfigSecret $) -}}
{{- else -}}
    {{- printf "%s-http-config-secret" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "thanos.createHttpConfigSecret" -}}
{{- if and (not .Values.existingHttpConfigSecret) (or .Values.https.enabled .Values.auth.basicAuthUsers .Values.httpConfig) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the Thanos Query Service Discovery configuration configmap.
*/}}
{{- define "thanos.query.SDConfigmapName" -}}
{{- if .Values.query.existingSDConfigmap -}}
    {{- printf "%s" (tpl .Values.query.existingSDConfigmap $) -}}
{{- else -}}
    {{- printf "%s-query-sd" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "thanos.query.createSDConfigmap" -}}
{{- if and .Values.query.sdConfig (not .Values.query.existingSDConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the Thanos Ruler configuration configmap.
*/}}
{{- define "thanos.ruler.configmapName" -}}
{{- if .Values.ruler.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.ruler.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-ruler" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the queryURL used by Thanos Ruler.
*/}}
{{- define "thanos.ruler.queryURL" -}}
{{- if and .Values.queryFrontend.enabled .Values.queryFrontend.ingress.enabled .Values.queryFrontend.ingress.hostname .Values.queryFrontend.ingress.overrideAlertQueryURL -}}
    {{- printf "%s://%s" (ternary "https" "http" .Values.queryFrontend.ingress.tls) (tpl .Values.queryFrontend.ingress.hostname .) -}}
{{- else -}}
{{- if .Values.ruler.queryURL -}}
    {{- printf "%s" (tpl .Values.ruler.queryURL $) -}}
{{- else -}}
    {{- printf "http://%s-query.%s.svc.%s:%d" (include "common.names.fullname" . ) .Release.Namespace .Values.clusterDomain (int  .Values.query.service.ports.http) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "thanos.ruler.createConfigmap" -}}
{{- if and .Values.ruler.config (not .Values.ruler.existingConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the Thanos storegateway configuration configmap.
*/}}
{{- define "thanos.storegateway.configmapName" -}}
{{- if .Values.storegateway.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.storegateway.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-storegateway" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Thanos Query Frontend configuration configmap.
*/}}
{{- define "thanos.queryFrontend.configmapName" -}}
{{- if .Values.queryFrontend.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.queryFrontend.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-query-frontend" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "thanos.queryFrontend.createConfigmap" -}}
{{- if and .Values.queryFrontend.config (not .Values.queryFrontend.existingConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "thanos.storegateway.createConfigmap" -}}
{{- if and (or .Values.storegateway.config .Values.indexCacheConfig .Values.bucketCacheConfig) (not .Values.storegateway.existingConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (bucketweb)
*/}}
{{- define "thanos.bucketweb.serviceAccountName" -}}
{{- if .Values.bucketweb.serviceAccount.create -}}
    {{ default (include "thanos.bucketweb.fullname" .) .Values.bucketweb.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.bucketweb.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (compactor)
*/}}
{{- define "thanos.compactor.serviceAccountName" -}}
{{- if .Values.compactor.serviceAccount.create -}}
    {{ default (include "thanos.compactor.fullname" .) .Values.compactor.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.compactor.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (query)
*/}}
{{- define "thanos.query.serviceAccountName" -}}
{{- if .Values.query.serviceAccount.create -}}
    {{ default (include "thanos.query.fullname" .) .Values.query.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.query.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (queryFrontend)
*/}}
{{- define "thanos.query-frontend.serviceAccountName" -}}
{{- if .Values.queryFrontend.serviceAccount.create -}}
    {{ default (include "thanos.query-frontend.fullname" .) .Values.queryFrontend.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.queryFrontend.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (receive)
*/}}
{{- define "thanos.receive.serviceAccountName" -}}
{{- if .Values.receive.serviceAccount.create -}}
    {{ default (include "thanos.receive.fullname" .) .Values.receive.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.receive.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (receiveDistributor)
*/}}
{{- define "thanos.receive-distributor.serviceAccountName" -}}
{{- if .Values.receiveDistributor.serviceAccount.create -}}
    {{ default (include "thanos.receive-distributor.fullname" .) .Values.receiveDistributor.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.receiveDistributor.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (ruler)
*/}}
{{- define "thanos.ruler.serviceAccountName" -}}
{{- if .Values.ruler.serviceAccount.create -}}
    {{ default (include "thanos.ruler.fullname" .) .Values.ruler.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.ruler.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (storegateway)
*/}}
{{- define "thanos.storegateway.serviceAccountName" -}}
{{- if .Values.storegateway.serviceAccount.create -}}
    {{ default (include "thanos.storegateway.fullname" .) .Values.storegateway.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.storegateway.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the Thanos Compactor pvc name
*/}}
{{- define "thanos.compactor.pvcName" -}}
{{- if .Values.compactor.persistence.existingClaim -}}
    {{- printf "%s" (tpl .Values.compactor.persistence.existingClaim $) -}}
{{- else -}}
    {{- printf "%s-compactor" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "thanos.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image -}}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "thanos.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "thanos.validateValues.objstore" .) -}}
{{- $messages := append $messages (include "thanos.validateValues.ruler.alertmanagers" .) -}}
{{- $messages := append $messages (include "thanos.validateValues.ruler.config" .) -}}
{{- $messages := append $messages (include "thanos.validateValues.sharded.service" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Thanos - Objstore configuration */}}
{{- define "thanos.validateValues.objstore" -}}
{{- if and (or .Values.bucketweb.enabled .Values.compactor.enabled .Values.ruler.enabled .Values.storegateway.enabled) (not (include "thanos.createObjstoreSecret" .)) ( not .Values.existingObjstoreSecret) -}}
thanos: objstore configuration
    When enabling Bucket Web, Compactor, Ruler or Store component,
    you must provide a valid objstore configuration.
    There are three alternatives to provide it:
      1) Provide it using the 'objstoreConfig' parameter
      2) Provide it using an existing Secret and using the 'existingObjstoreSecret' parameter
      3) Put your objstore.yml under the 'files/conf/' directory
{{- end -}}
{{- end -}}

{{/* Validate values of Thanos - Ruler Alertmanager(s) */}}
{{- define "thanos.validateValues.ruler.alertmanagers" -}}
{{/* Check the emptiness of the values */}}
{{- if and .Values.ruler.enabled ( and (empty .Values.ruler.alertmanagers) (empty .Values.ruler.alertmanagersConfig)) -}}
thanos: ruler alertmanagers
    When enabling Ruler component, you must provide either alermanagers URL(s) or an alertmanagers configuration.
    See https://github.com/thanos-io/thanos/blob/ef94b7e6468d94e2c47943ebf5fc6db24c48d867/docs/components/rule.md#flags and https://github.com/thanos-io/thanos/blob/ef94b7e6468d94e2c47943ebf5fc6db24c48d867/docs/components/rule.md#Configuration for more information.
{{- end -}}
{{/* Check that the values are defined in a mutually exclusive manner */}}
{{- if and .Values.ruler.enabled .Values.ruler.alertmanagers .Values.ruler.alertmanagersConfig -}}
thanos: ruler alertmanagers
    Only one of the following can be used at one time:
        * .Values.ruler.alertmanagers
        * .Values.ruler.alertmanagersConfig
    Otherwise, the configurations will collide and Thanos will error out. Please consolidate your configuration
    into one of the above options.
{{- end -}}
{{- end -}}

{{/* Validate values of Thanos - Ruler configuration */}}
{{- define "thanos.validateValues.ruler.config" -}}
{{- if and .Values.ruler.enabled (not (include "thanos.ruler.createConfigmap" .)) (not .Values.ruler.existingConfigmap) -}}
thanos: ruler configuration
    When enabling Ruler component, you must provide a valid configuration.
    There are three alternatives to provide it:
      1) Provide it using the 'ruler.config' parameter
      2) Provide it using an existing Configmap and using the 'ruler.existingConfigmap' parameter
      3) Put your ruler.yml under the 'files/conf/' directory
{{- end -}}
{{- end -}}

{{/* Validate values of Thanos - number of sharded service properties */}}
{{- define "thanos.validateValues.sharded.service" -}}
{{- if and .Values.storegateway.sharded.enabled (not (empty .Values.storegateway.sharded.service.clusterIPs) ) -}}
{{- if eq "false" (include "thanos.validateValues.storegateway.sharded.length" (dict "property" $.Values.storegateway.sharded.service.clusterIPs "context" $) ) }}
thanos: storegateway.sharded.service.clusterIPs
    The number of shards does not match the number of ClusterIPs $.Values.storegateway.sharded.service.clusterIPs
{{- end -}}
{{- end -}}
{{- if and .Values.storegateway.sharded.enabled (not (empty .Values.storegateway.sharded.service.loadBalancerIPs) ) -}}
{{- if eq "false" (include "thanos.validateValues.storegateway.sharded.length" (dict "property" $.Values.storegateway.sharded.service.loadBalancerIPs "context" $) ) }}
thanos: storegateway.sharded.service.loadBalancerIPs
    The number of shards does not match the number of loadBalancerIPs $.Values.storegateway.sharded.service.loadBalancerIPs
{{- end -}}
{{- end -}}
{{- if and .Values.storegateway.sharded.enabled (not (empty .Values.storegateway.sharded.service.http.nodePorts) ) -}}
{{- if eq "false" (include "thanos.validateValues.storegateway.sharded.length" (dict "property" $.Values.storegateway.sharded.service.http.nodePorts "context" $) ) }}
thanos: storegateway.sharded.service.http.nodePorts
    The number of shards does not match the number of http.nodePorts $.Values.storegateway.sharded.service.http.nodePorts
{{- end -}}
{{- end -}}
{{- if and .Values.storegateway.sharded.enabled (not (empty .Values.storegateway.sharded.service.grpc.nodePorts) ) -}}
{{- if eq "false" (include "thanos.validateValues.storegateway.sharded.length" (dict "property" $.Values.storegateway.sharded.service.grpc.nodePorts "context" $) ) }}
thanos: storegateway.sharded.service.grpc.nodePorts
    The number of shards does not match the number of grpc.nodePorts $.Values.storegateway.sharded.service.grpc.nodePorts
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "thanos.validateValues.storegateway.sharded.length" -}}
{{/* Get number of shards */}}
{{- $shards := int 0 }}
{{- if .context.Values.storegateway.sharded.hashPartitioning.shards }}
  {{- $shards = int .context.Values.storegateway.sharded.hashPartitioning.shards }}
{{- else }}
  {{- $shards = len .context.Values.storegateway.sharded.timePartitioning }}
{{- end }}
{{- $propertyLength := (len .property) -}}
{{/* Validate property */}}
{{- if ne $shards $propertyLength -}}
false
{{- end }}
{{- end }}

{{/*
Return true if a hashring configmap object should be created
*/}}
{{- define "thanos.receive.createConfigmap" -}}
{{- if and .Values.receive.enabled (not .Values.receive.existingConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the Thanos receive hashring configuration configmap.
*/}}
{{- define "thanos.receive.configmapName" -}}
{{- if .Values.receive.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.receive.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-receive" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/* Return the proper pod fqdn of the replica.
Usage:
{{ include "thanos.receive.podFqdn" (dict "root" . "extra" $suffix ) }}
*/}}
{{- define "thanos.receive.podFqdn" -}}
{{- printf "\"%s-receive-%d.%s-receive-headless.%s.svc.%s:10901\"" (include "common.names.fullname" .root ) .extra (include "common.names.fullname" .root ) .root.Release.Namespace .root.Values.clusterDomain -}}
{{- end -}}

{{/* Returns a proper configuration when no config is specified
Usage:
{{ include "thanos.receive.config" . }}
*/}}
{{- define "thanos.receive.config" -}}
{{- if not .Values.receive.existingConfigmap }}
{{- if not .Values.receive.config -}}
{{- if .Values.receive.service.additionalHeadless -}}
{{- $count := int .Values.receive.replicaCount -}}
{{- $endpoints_dict := dict "endpoints" (list)  -}}
{{- $root := . -}}
{{- range $i := until $count -}}
{{- $data := dict "root" $root "extra" $i -}}
{{- $noop := (include "thanos.receive.podFqdn" $data) | append $endpoints_dict.endpoints | set $endpoints_dict "endpoints" -}}
{{- end -}}
[
  {
    "endpoints": [
{{ join ",\n" $endpoints_dict.endpoints | indent 6 }}
    ]
  }
]
{{- else -}}
[
  {
    "endpoints": [
        "127.0.0.1:10901"
    ]
  }
]
{{- end -}}
{{- else -}}
{{- if (typeIs "string" .Values.receive.config) }}
{{- .Values.receive.config -}}
{{- else -}}
{{- .Values.receive.config | toPrettyJson -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Labels to use on serviceMonitor.spec.selector and svc.metadata.labels
*/}}
{{- define "thanos.servicemonitor.matchLabels" -}}
{{- if and .Values.metrics.enabled .Values.metrics.serviceMonitor.enabled -}}
prometheus-operator/monitor: 'true'
{{- end }}
{{- end }}

{{/*
Labels to use on serviceMonitor.spec.selector
*/}}
{{- define "thanos.servicemonitor.selector" -}}
{{- include "thanos.servicemonitor.matchLabels" $ }}
{{ if .Values.metrics.serviceMonitor.selector -}}
{{- include "common.tplvalues.render" (dict "value" .Values.metrics.serviceMonitor.selector "context" $)}}
{{- end -}}
{{- end -}}
