{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Grafana Mimir image name
*/}}
{{- define "grafana-mimir.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.mimir.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Mimir gateway image name
*/}}
{{- define "grafana-mimir.gateway.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.gateway.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper the name of the secret with the auth credentials for the gateway.
*/}}
{{- define "grafana-mimir.gateway.secretName" -}}
{{- if not .Values.gateway.auth.existingSecret }}
  {{- include "grafana-mimir.gateway.fullname" . }}
{{- else }}
  {{- printf "%s" .Values.gateway.auth.existingSecret -}}
{{- end }}
{{- end -}}

{{/*
Return the proper Grafana Mimir compactor fullname
*/}}
{{- define "grafana-mimir.compactor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "compactor" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir distributor fullname
*/}}
{{- define "grafana-mimir.distributor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "distributor" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir ingester fullname
*/}}
{{- define "grafana-mimir.ingester.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "ingester" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir querier fullname
*/}}
{{- define "grafana-mimir.querier.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "querier" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir query-frontend fullname
*/}}
{{- define "grafana-mimir.query-frontend.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-frontend" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir store-gateway fullname
*/}}
{{- define "grafana-mimir.store-gateway.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "store-gateway" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir gateway fullname
*/}}
{{- define "grafana-mimir.gateway.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "gateway" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir ruler fullname
*/}}
{{- define "grafana-mimir.ruler.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "ruler" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir ruler fullname
*/}}
{{- define "grafana-mimir.gossip-ring.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "gossip-ring" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir alertmanager fullname
*/}}
{{- define "grafana-mimir.alertmanager.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "alertmanager" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir overrides-exporter fullname
*/}}
{{- define "grafana-mimir.overrides-exporter.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "overrides-exporter" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Mimir query-scheduler fullname
*/}}
{{- define "grafana-mimir.query-scheduler.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-scheduler" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the Grafana Mimir configuration configmap.
*/}}
{{- define "grafana-mimir.mimir.configmapName" -}}
{{- if .Values.mimir.existingConfigmap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.mimir.existingConfigmap "context" .) -}}
{{- else }}
    {{- printf "%s" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "grafana-mimir.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "grafana-mimir.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.mimir.image .Values.gateway.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "grafana-mimir.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified memcached (chunks) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-mimir.memcached-chunks.fullname" -}}
{{- $name := default "memcachedchunks" .Values.memcachedchunks.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (chunks) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-mimir.memcached-chunks.host" -}}
{{- $port := "" -}}
{{- if .Values.externalMemcachedChunks.host -}}
  {{- $servicePortString := printf "%v" .Values.externalMemcachedChunks.port -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" .Values.externalMemcachedChunks.host $port }}
{{- else -}}
  {{- $servicePortString := printf "%v" .Values.memcachedchunks.service.ports.memcached -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" (include "grafana-mimir.memcached-chunks.fullname" .) $port }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (index) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-mimir.memcached-index.fullname" -}}
{{- $name := default "memcachedindex" .Values.memcachedindex.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (index) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-mimir.memcached-index.host" -}}
{{- $port := "" -}}
{{- if .Values.externalMemcachedIndex.host -}}
  {{- $servicePortString := printf "%v" .Values.externalMemcachedIndex.port -}}
    {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" .Values.externalMemcachedIndex.host $port }}
{{- else -}}
  {{- $servicePortString := printf "%v" .Values.memcachedindex.service.ports.memcached -}}
    {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" (include "grafana-mimir.memcached-index.fullname" .) $port }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (frontend) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-mimir.memcached-frontend.fullname" -}}
{{- $name := default "memcachedfrontend" .Values.memcachedfrontend.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (frontend) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-mimir.memcached-frontend.host" -}}
{{- $port := "" -}}
{{- if .Values.externalMemcachedFrontend.host -}}
  {{- $servicePortString := printf "%v" .Values.externalMemcachedFrontend.port -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" .Values.externalMemcachedFrontend.host $port }}
{{- else -}}
  {{- $servicePortString := printf "%v" .Values.memcachedfrontend.service.ports.memcached -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" (include "grafana-mimir.memcached-frontend.fullname" .) $port }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (metadata) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-mimir.memcached-metadata.fullname" -}}
{{- $name := default "memcachedmetadata" .Values.memcachedmetadata.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (metadata) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-mimir.memcached-metadata.host" -}}
{{- $port := "" -}}
{{- if .Values.externalMemcachedMetadata.host -}}
  {{- $servicePortString := printf "%v" .Values.externalMemcachedMetadata.port -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" .Values.externalMemcachedMetadata.host $port }}
{{- else -}}
  {{- $servicePortString := printf "%v" .Values.memcachedmetadata.service.ports.memcached -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" (include "grafana-mimir.memcached-metadata.fullname" .) $port }}
{{- end -}}
{{- end -}}

{{/*
Return MinIO(TM) fullname
*/}}
{{- define "grafana-mimir.minio.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "minio" "chartValues" .Values.minio "context" $) -}}
{{- end -}}


{{/*
Return the S3 credentials secret name
*/}}
{{- define "grafana-mimir.minio.secretName" -}}
    {{- if .Values.minio.auth.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.minio.auth.existingSecret "context" .) -}}
    {{- else -}}
    {{- print (include "grafana-mimir.minio.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Return the S3 access key id inside the secret
*/}}
{{- define "grafana-mimir.minio.accessKeyIDKey" -}}
    {{- print "root-user"  -}}
{{- end -}}

{{/*
Return the S3 secret access key inside the secret
*/}}
{{- define "grafana-mimir.minio.secretAccessKeyKey" -}}
    {{- print "root-password"  -}}
{{- end -}}


{{/*
Check if there are rolling tags in the images
*/}}
{{- define "grafana-mimir.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.mimir.image }}
{{- include "common.warnings.rollingTag" .Values.gateway.image }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end }}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "grafana-mimir.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "grafana-mimir.validateValues.ingester.replicaCount" .) -}}
{{- $messages := append $messages (include "grafana-mimir.validateValues.memcachedchunks" .) -}}
{{- $messages := append $messages (include "grafana-mimir.validateValues.memcachedindex" .) -}}
{{- $messages := append $messages (include "grafana-mimir.validateValues.memcachedmetadata" .) -}}
{{- $messages := append $messages (include "grafana-mimir.validateValues.memcachedfrontend" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{/* Validate values of Grafana Mimir - Number of ingester nodes */}}
{{- define "grafana-mimir.validateValues.ingester.replicaCount" -}}
{{- if lt (int .Values.ingester.replicaCount) 2 -}}
grafana-mimir: Ingester replicaCount
    Please set ingester.replicaCount greater than 1 (--set ingester.replicaCount=2)
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Mimir - Memcached (Chunks) */}}
{{- define "grafana-mimir.validateValues.memcachedchunks" -}}
{{- if and .Values.memcachedchunks.enabled .Values.externalMemcachedChunks.host -}}
grafana-mimir: Memcached Chunks
    You can only use one chunk cache.
    Please choose installing a Memcached chart (--set memcachedchunks.enabled=true) or
    using an external database (--set externalMemcachedChunks.host)
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Mimir - Memcached (Index) */}}
{{- define "grafana-mimir.validateValues.memcachedindex" -}}
{{- if and .Values.memcachedindex.enabled .Values.externalMemcachedIndex.host -}}
grafana-mimir: Memcached Index
    You can only use one index-write cache.
    Please choose installing a Memcached chart (--set memcachedIndexWrites.enabled=true) or
    using an external database (--set externalMemcachedIndex.host)
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Mimir - Memcached (Metadata) */}}
{{- define "grafana-mimir.validateValues.memcachedmetadata" -}}
{{- if and .Values.memcachedindex.enabled .Values.externalMemcachedMetadata.host -}}
grafana-mimir: Memcached Metadata
    You can only use one chunk cache.
    Please choose installing a Memcached chart (--set memcachedmetadata.enabled=true) or
    using an external database (--set externalMemcachedMetadata.host)
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Mimir - Memcached (Frontend) */}}
{{- define "grafana-mimir.validateValues.memcachedfrontend" -}}
{{- if and .Values.memcachedfrontend.enabled .Values.externalMemcachedFrontend.host -}}
grafana-mimir: Memcached Frontend
    You can only use one frontend cache.
    Please choose installing a Memcached chart (--set memcachedfrontend.enabled=true) or
    using an external database (--set externalMemcachedFrontend.host)
{{- end -}}
{{- end -}}
