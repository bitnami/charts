{{/* vim: set filetype=mustache: */}}


{{/*
Return the proper jaeger&trade; image name
*/}}
{{- define "jaeger.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "jaeger.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image .Values.backup.uploadProviders.google.image .Values.backup.uploadProviders.azure.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the query deployment
*/}}
{{- define "jaeger.query.fullname" -}}
    {{ printf "%s-query" (include "common.names.fullname" .) }}
{{- end -}}

{{/*
Create the name of the collector deployment
*/}}
{{- define "jaeger.collector.fullname" -}}
    {{ printf "%s-collector" (include "common.names.fullname" .) }}
{{- end -}}

{{/*
Return the cassandra subchart password.
*/}}
{{- define "jaeger.cassandraSubChartPassword" -}}
{{- if not (empty .Values.cassandra.dbUser.password) -}}
    {{- .Values.cassandra.dbUser.password -}}
{{- else -}}
    {{- include "getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" (include "common.names.fullname" .) "Length" 10 "Key" "cassandra-password")  -}}
{{- end -}}
{{- end -}}

{{/*
Return the jaeger&trade; initialization scripts configmap.
*/}}
{{- define "jaeger.initdbScriptsConfigmapName" -}}
{{- if .Values.jaeger.initdbScriptsCM -}}
    {{- printf "%s" (tpl .Values.jaeger.initdbScriptsCM $) -}}
{{- else -}}
    {{- printf "%s-initdb-scripts" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the jaeger&trade; initialization scripts secret.
*/}}
{{- define "jaeger.initdbScriptsSecret" -}}
{{- printf "%s" (tpl .Values.jaeger.initdbScriptsSecret $) -}}
{{- end -}}
