{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Consul image name
*/}}
{{- define "consul.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper metrics image name
*/}}
{{- define "consul.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "consul.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "consul.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "consul.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return retry_join endpoint for members to join the cluster
Usage:
{{ include "consul.retryjoin.endpoint" . }}
*/}}
{{- define "consul.retryjoin.endpoint" -}}
    {{- $name := printf "%s-headless" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- $domain := .Values.clusterDomain -}}
    {{- $namespace := .Release.Namespace -}}
    {{- printf "%s.%s.svc.%s" $name $namespace $domain -}}
{{- end -}}

{{/*
Return the configmap with the Consul configuration
*/}}
{{- define "consul.configmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s" (printf "%s-configuration" (include "common.names.fullname" .)) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created for Consul
*/}}
{{- define "consul.createConfigmap" -}}
{{- if and .Values.configuration (not .Values.existingConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}
