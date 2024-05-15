{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper tensorflow-resnet server image name
*/}}
{{- define "tensorflow-resnet.server.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.server.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper tensorflow-resnet client image name
*/}}
{{- define "tensorflow-resnet.client.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.client.image "global" .Values.global) }}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "tensorflow-resnet.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "tensorflow-resnet.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.server.image .Values.client.image) "global" .Values.global) -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "tensorflow-resnet.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.server.image -}}
{{- include "common.warnings.rollingTag" .Values.client.image -}}
{{- end -}}
