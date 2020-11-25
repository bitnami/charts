{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Logstash image name
*/}}
{{- define "logstash.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Prometheus metrics image name
*/}}
{{- define "logstash.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "logstash.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the Logstash configuration configmap.
*/}}
{{- define "logstash.configmapName" -}}
{{- if .Values.existingConfiguration -}}
    {{- printf "%s" (tpl .Values.existingConfiguration $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "logstash.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "logstash.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "logstash.validateValues.metrics" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Logstash - Monitoring API must be enabled when metrics are enabled */}}
{{- define "logstash.validateValues.metrics" -}}
{{- if and .Values.metrics.enabled (not .Values.enableMonitoringAPI) -}}
logstash: metrics
    The Logstash Monitoring API must be enabled when metrics are enabled (metrics.enabled=true).
    Please enable the Montoring API (--set enableMonitoringAPI="true")
{{- end -}}
{{- end -}}
