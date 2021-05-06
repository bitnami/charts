{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "node.mongodb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mongodb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Custom template to get proper service name
*/}}
{{- define "node.secretName" -}}
  {{- if .Values.externaldb.secretName }}
    {{- printf "%s" .Values.externaldb.secretName }}
  {{- else }}
    {{- printf "%s-%s" .Release.Name "mongodb-binding" | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end -}}

{{/*
Return the proper Node image name
*/}}
{{- define "node.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper git image name
*/}}
{{- define "git.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.git.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "node.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image .Values.git.image) "global" .Values.global) -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "node.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.git.image }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "node.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Storage Class
*/}}
{{- define "node.storageClass" -}}
{{- include "common.storage.class" (dict "persistence" .Values.persistence "global" .Values.global) -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "node.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "node.validateValues.database" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Node - Database */}}
{{- define "node.validateValues.database" -}}
{{- if and .Values.mongodb.enabled .Values.externaldb.enabled -}}
node: Database
    You can only use one database.
    Please choose installing a MongoDB(R) chart (--set mongodb.enabled=true) or
    using an external database (--set externaldb.enabled=true)
{{- end -}}
{{- end -}}
