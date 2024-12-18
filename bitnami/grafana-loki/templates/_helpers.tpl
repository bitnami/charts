{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Grafana Loki image name
*/}}
{{- define "grafana-loki.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.loki.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Loki compactor fullname
*/}}
{{- define "grafana-loki.compactor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "compactor" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Loki distributor fullname
*/}}
{{- define "grafana-loki.distributor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "distributor" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Loki gateway fullname
*/}}
{{- define "grafana-loki.gateway.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "gateway" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Loki index-gateway fullname
*/}}
{{- define "grafana-loki.index-gateway.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "index-gateway" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Loki ingester fullname
*/}}
{{- define "grafana-loki.ingester.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "ingester" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Loki querier fullname
*/}}
{{- define "grafana-loki.querier.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "querier" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Loki query-frontend fullname
*/}}
{{- define "grafana-loki.query-frontend.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-frontend" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Return the proper Grafana Loki query-scheduler fullname
*/}}
{{- define "grafana-loki.query-scheduler.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-scheduler" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Loki ruler fullname
*/}}
{{- define "grafana-loki.ruler.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "ruler" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Loki table-manager fullname
*/}}
{{- define "grafana-loki.table-manager.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "table-manager" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Loki gossip-ring fullname
*/}}
{{- define "grafana-loki.gossip-ring.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "gossip-ring" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Loki promtail fullname
*/}}
{{- define "grafana-loki.promtail.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "promtail" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Grafana Loki image name
*/}}
{{- define "grafana-loki.promtail.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.promtail.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Loki image name
*/}}
{{- define "grafana-loki.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Loki image name
*/}}
{{- define "grafana-loki.gateway.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.gateway.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "grafana-loki.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.loki.image .Values.gateway.image .Values.promtail.image .Values.volumePermissions.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "grafana-loki.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the Loki configuration configmap.
*/}}
{{- define "grafana-loki.loki.configmapName" -}}
{{- if .Values.loki.existingConfigmap -}}
    {{- .Values.loki.existingConfigmap -}}
{{- else }}
    {{- printf "%s" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the promtail configuration configmap.
*/}}
{{- define "grafana-loki.promtail.secretName" -}}
{{- if .Values.promtail.existingSecret -}}
    {{- .Values.promtail.existingSecret -}}
{{- else }}
    {{- include "grafana-loki.promtail.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
Get the promtail configuration configmap.
*/}}
{{- define "grafana-loki.gateway.secretName" -}}
{{- if .Values.gateway.auth.existingSecret -}}
    {{- .Values.gateway.auth.existingSecret -}}
{{- else }}
    {{- include "grafana-loki.gateway.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "grafana-loki.promtail.serviceAccountName" -}}
{{- if .Values.promtail.serviceAccount.create -}}
    {{ default (printf "%s" (include "grafana-loki.promtail.fullname" .)) .Values.promtail.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.promtail.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (chunks) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-loki.memcached-chunks.fullname" -}}
{{- $name := default "memcachedchunks" .Values.memcachedchunks.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (chunks) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-loki.memcached-chunks.host" -}}
{{- $port := "" -}}
{{- if .Values.externalMemcachedChunks.host -}}
  {{- $servicePortString := printf "%v" .Values.externalMemcachedChunks.port -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" .Values.externalMemcachedChunks.host $port }}
{{- else -}}
  {{- $servicePortString := printf "%v" .Values.memcachedchunks.service.ports.memcached -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" (include "grafana-loki.memcached-chunks.fullname" .) $port }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (index-queries) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-loki.memcached-index-queries.fullname" -}}
{{- $name := default "memcachedindexqueries" .Values.memcachedindexqueries.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (index-queries) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-loki.memcached-index-queries.host" -}}
{{- $port := "" -}}
{{- if .Values.externalMemcachedIndexQueries.host -}}
  {{- $servicePortString := printf "%v" .Values.externalMemcachedIndexQueries.port -}}
    {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" .Values.externalMemcachedIndexQueries.host $port }}
{{- else -}}
  {{- $servicePortString := printf "%v" .Values.memcachedindexqueries.service.ports.memcached -}}
    {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" (include "grafana-loki.memcached-index-queries.fullname" .) $port }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (frontend) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-loki.memcached-frontend.fullname" -}}
{{- $name := default "memcachedfrontend" .Values.memcachedfrontend.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (frontend) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-loki.memcached-frontend.host" -}}
{{- $port := "" -}}
{{- if .Values.externalMemcachedFrontend.host -}}
  {{- $servicePortString := printf "%v" .Values.externalMemcachedFrontend.port -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" .Values.externalMemcachedFrontend.host $port }}
{{- else -}}
  {{- $servicePortString := printf "%v" .Values.memcachedfrontend.service.ports.memcached -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" (include "grafana-loki.memcached-frontend.fullname" .) $port }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (index-writes) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-loki.memcached-index-writes.fullname" -}}
{{- $name := default "memcachedindexwrites" .Values.memcachedindexwrites.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified memcached (index-writes) name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-loki.memcached-index-writes.host" -}}
{{- $port := "" -}}
{{- if .Values.externalMemcachedIndexWrites.host -}}
  {{- $servicePortString := printf "%v" .Values.externalMemcachedIndexWrites.port -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" .Values.externalMemcachedIndexWrites.host $port }}
{{- else -}}
  {{- $servicePortString := printf "%v" .Values.memcachedindexwrites.service.ports.memcached -}}
  {{- $port = printf ":%s" $servicePortString -}}
  {{- printf "%s%s" (include "grafana-loki.memcached-index-writes.fullname" .) $port }}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "grafana-loki.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.loki.image }}
{{- include "common.warnings.rollingTag" .Values.promtail.image }}
{{- include "common.warnings.rollingTag" .Values.gateway.image }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "grafana-loki.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "grafana-loki.validateValues.memcachedChunks" .) -}}
{{- $messages := append $messages (include "grafana-loki.validateValues.memcachedIndexWrites" .) -}}
{{- $messages := append $messages (include "grafana-loki.validateValues.memcachedIndexQueries" .) -}}
{{- $messages := append $messages (include "grafana-loki.validateValues.memcachedFrontend" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Loki - Memcached (Chunks) */}}
{{- define "grafana-loki.validateValues.memcachedChunks" -}}
{{- if and .Values.memcachedchunks.enabled .Values.externalMemcachedChunks.host -}}
grafana-loki: Memcached Chunks
    You can only use one chunk cache.
    Please choose installing a Memcached chart (--set memcachedChunks.enabled=true) or
    using an external database (--set externalMemcachedChunks.host)
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Loki - Memcached (IndexWrites) */}}
{{- define "grafana-loki.validateValues.memcachedIndexWrites" -}}
{{- if and .Values.memcachedindexwrites.enabled .Values.externalMemcachedIndexWrites.host -}}
grafana-loki: Memcached Index Writes
    You can only use one index-write cache.
    Please choose installing a Memcached chart (--set memcachedIndexWrites.enabled=true) or
    using an external database (--set externalMemcachedIndexWrites.host)
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Loki - Memcached (IndexQueries) */}}
{{- define "grafana-loki.validateValues.memcachedIndexQueries" -}}
{{- if and .Values.memcachedindexqueries.enabled .Values.externalMemcachedIndexQueries.host -}}
grafana-loki: Memcached Index Queries
    You can only use one chunk cache.
    Please choose installing a Memcached chart (--set memcachedIndexQueries.enabled=true) or
    using an external database (--set externalMemcachedIndexQueries.host)
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Loki - Memcached (Frontend) */}}
{{- define "grafana-loki.validateValues.memcachedFrontend" -}}
{{- if and .Values.memcachedfrontend.enabled .Values.externalMemcachedFrontend.host -}}
grafana-loki: Memcached Frontend
    You can only use one frontend cache.
    Please choose installing a Memcached chart (--set memcachedFrontend.enabled=true) or
    using an external database (--set externalMemcachedFrontend.host)
{{- end -}}
{{- end -}}
