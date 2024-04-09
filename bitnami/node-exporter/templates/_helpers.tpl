{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Node Exporter image name
*/}}
{{- define "node-exporter.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names for Node Exporter image
*/}}
{{- define "node-exporter.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "node-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "node-exporter.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "node-exporter.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "node-exporter.validateValues.resourceType" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Node Exporter - resource type */}}
{{- define "node-exporter.validateValues.resourceType" -}}
{{- if and (not (eq .Values.resourceType "daemonset")) (not (eq .Values.resourceType "deployment")) -}}
node-exporter: resource-type
    Resource type {{ .Values.resourceType }} is not valid, only "daemonset" and "deployment" are allowed
{{- end -}}
{{- end -}}