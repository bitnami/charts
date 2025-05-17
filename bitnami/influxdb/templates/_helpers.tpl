{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper InfluxDB&trade; Core image name
*/}}
{{- define "influxdb.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "influxdb.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.defaultInitContainers.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "influxdb.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.defaultInitContainers.volumePermissions.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the ServiceAccount to use
*/}}
{{- define "influxdb.serviceAccountName" -}}
{{- if or .Values.serviceAccount.enabled .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the InfluxDB&trade; Core Store secret name
*/}}
{{- define "influxdb.store.secret.name" -}}
{{- if eq .Values.objectStore "s3" }}
    {{- if .Values.s3.auth.existingSecret -}}
        {{- tpl .Values.s3.auth.existingSecret . -}}
    {{- else }}
        {{- printf "%s-s3" (include "common.names.fullname" .) -}}
    {{- end -}}
{{- else if eq .Values.objectStore "google" }}
    {{- if .Values.google.auth.existingSecret -}}
        {{- tpl .Values.google.auth.existingSecret . -}}
    {{- else }}
        {{- printf "%s-google" (include "common.names.fullname" .) -}}
    {{- end -}}
{{- else if eq .Values.objectStore "azure" }}
    {{- if .Values.azure.auth.existingSecret -}}
        {{- tpl .Values.azure.auth.existingSecret . -}}
    {{- else }}
        {{- printf "%s-azure" (include "common.names.fullname" .) -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if a secret should be created for InfluxDB&trade; Core Store credentials
*/}}
{{- define "influxdb.store.secret.create" -}}
{{- if or (and (eq .Values.objectStore "s3") (not .Values.s3.auth.existingSecret)) (and (eq .Values.objectStore "google") (not .Values.google.auth.existingSecret)) (and (eq .Values.objectStore "azure") (not .Values.azure.auth.existingSecret)) }}
true
{{- end -}}
{{- end -}}

{{/*
Return the InfluxDB&trade; Core initialization scripts ConfigMap name.
*/}}
{{- define "influxdb.initdbScriptsConfigmapName" -}}
{{- if .Values.initdbScriptsCM -}}
    {{- print (tpl .Values.initdbScriptsCM .) -}}
{{- else -}}
    {{- printf "%s-initdb-scripts" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the InfluxDB&trade; Core initialization scripts Secret name
*/}}
{{- define "influxdb.initdbScriptsSecret" -}}
{{- print (tpl .Values.initdbScriptsSecret .) -}}
{{- end -}}
