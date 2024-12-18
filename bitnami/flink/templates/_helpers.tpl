{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper flink image name
*/}}
{{- define "flink.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "flink.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the jobmanager deployment
*/}}
{{- define "flink.jobmanager.fullname" -}}
    {{ printf "%s-jobmanager" (include "common.names.fullname" .)  | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create the name of the taskmanager deployment
*/}}
{{- define "flink.taskmanager.fullname" -}}
    {{ printf "%s-taskmanager" (include "common.names.fullname" .)  | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create the name of the service account to use for the taskmanager
*/}}
{{- define "flink.taskmanager.serviceAccountName" -}}
{{- if .Values.taskmanager.serviceAccount.create -}}
    {{ default (include "flink.taskmanager.fullname" .) .Values.taskmanager.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.taskmanager.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the jobmanager
*/}}
{{- define "flink.jobmanager.serviceAccountName" -}}
{{- if .Values.jobmanager.serviceAccount.create -}}
    {{ default (include "flink.jobmanager.fullname" .) .Values.jobmanager.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.jobmanager.serviceAccount.name }}
{{- end -}}
{{- end -}}
