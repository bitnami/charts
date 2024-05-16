{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Grafana Tempo image name
*/}}
{{- define "grafana-tempo.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.tempo.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Tempo compactor fullname
*/}}
{{- define "grafana-tempo.compactor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "compactor" -}}
{{- end -}}

{{/*
Return the proper Grafana Tempo distributor fullname
*/}}
{{- define "grafana-tempo.distributor.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "distributor" -}}
{{- end -}}

{{/*
Return the proper Grafana Tempo metrics-generator fullname
*/}}
{{- define "grafana-tempo.metrics-generator.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "metrics-generator" -}}
{{- end -}}

{{/*
Return the proper Grafana Tempo ingester fullname
*/}}
{{- define "grafana-tempo.ingester.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "ingester" -}}
{{- end -}}

{{/*
Return the proper Grafana Tempo querier fullname
*/}}
{{- define "grafana-tempo.querier.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "querier" -}}
{{- end -}}

{{/*
Return the proper Grafana Tempo query-frontend fullname
*/}}
{{- define "grafana-tempo.query-frontend.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "query-frontend" -}}
{{- end -}}

{{/*
Return the proper Grafana Tempo vulture fullname
*/}}
{{- define "grafana-tempo.vulture.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "vulture" -}}
{{- end -}}

{{/*
Return the proper Grafana Tempo gossip-ring fullname
*/}}
{{- define "grafana-tempo.gossip-ring.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "gossip-ring" -}}
{{- end -}}

{{/*
Return the proper Grafana Tempo image name
*/}}
{{- define "grafana-tempo.queryImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.queryFrontend.query.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Tempo image name
*/}}
{{- define "grafana-tempo.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Grafana Tempo image name
*/}}
{{- define "grafana-tempo.vultureImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.vulture.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "grafana-tempo.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.tempo.image .Values.vulture.image .Values.queryFrontend.query.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "grafana-tempo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the Tempo configuration configmap.
*/}}
{{- define "grafana-tempo.tempoConfigmapName" -}}
{{- if .Values.tempo.existingConfigmap -}}
    {{- .Values.tempo.existingConfigmap -}}
{{- else }}
    {{- printf "%s-tempo" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the Tempo overrides  configmap.
*/}}
{{- define "grafana-tempo.overridesConfigmapName" -}}
{{- if .Values.tempo.existingOverridesConfigmap -}}
    {{- .Values.tempo.existingOverridesConfigmap -}}
{{- else }}
    {{- printf "%s-overrides" (include "common.names.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the Tempo overrides  configmap.
*/}}
{{- define "grafana-tempo.queryConfigmapName" -}}
{{- if .Values.queryFrontend.query.existingConfigmap -}}
    {{- .Values.queryFrontend.query.existingConfigmap -}}
{{- else }}
    {{- include "grafana-tempo.query-frontend.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified memcached name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-tempo.memcached.fullname" -}}
{{- $name := default "memcached" .Values.memcached.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified memcached name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "grafana-tempo.memcached.url" -}}
{{- $port := "" -}}
{{- if .Values.externalMemcached.host -}}
  {{- $servicePortString := printf "%v" .Values.externalMemcached.port -}}
  {{- if (not (eq $servicePortString "11211")) -}}
    {{- $port = printf ":%s" $servicePortString -}}
  {{- end -}}
  {{- printf "%s%s" .Values.externalMemcached.host $port }}
{{- else -}}
  {{- $servicePortString := printf "%v" .Values.memcached.service.ports.memcached -}}
  {{- if (not (eq $servicePortString "11211")) -}}
    {{- $port = printf ":%s" $servicePortString -}}
  {{- end -}}
  {{- printf "%s%s" (include "grafana-tempo.memcached.fullname" .) $port }}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "grafana-tempo.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.tempo.image }}
{{- include "common.warnings.rollingTag" .Values.queryFrontend.query.image }}
{{- include "common.warnings.rollingTag" .Values.vulture.image }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "grafana-tempo.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "grafana-tempo.validateValues.vulture" .) -}}
{{- $messages := append $messages (include "grafana-tempo.validateValues.memcached" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Tempo - Memcached */}}
{{- define "grafana-tempo.validateValues.vulture" -}}
{{- if not (and .Values.vulture.enabled .Values.tempo.traces.jaeger.grpc) -}}
grafana-tempo: Vulture and GRPC
    In order to use Vulture, Jaeger GRPC traces must be enabled. Please set tempo.traces.jaeger.grpc=true when installing the chart.
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Tempo - Memcached */}}
{{- define "grafana-tempo.validateValues.memcached" -}}
{{- if and .Values.memcached.enabled .Values.externalMemcached.host -}}
jupyherhub: Memcached
    You can only use one database.
    Please choose installing a Memcached chart (--set memcached.enabled=true) or
    using an external database (--set externalMemcached.host)
{{- end -}}
{{- if and (not .Values.memcached.enabled) (not .Values.externalMemcached.host) -}}
jupyherhub: NoMemcached
    You did not set any cache.
    Please choose installing a Memcached chart (--set memcached.enabled=true) or
    using an external instance (--set externalMemcached.host)
{{- end -}}
{{- end -}}
