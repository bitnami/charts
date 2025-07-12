{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Grafana Alloy image name
*/}}
{{- define "grafana-alloy.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.alloy.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper config reloader image name
*/}}
{{- define "config-reloader.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.configReloader.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "grafana-alloy.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.alloy.image .Values.configReloader.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "grafana-alloy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Name of the Grafana Alloy Secret
*/}}
{{- define "grafana-alloy.secretName" -}}
{{- if .Values.alloy.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.alloy.existingSecret "context" $) -}}
{{- else -}}
    {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Grafana Alloy - resource type */}}
{{- define "grafana-alloy.validateValues.resourceType" -}}
{{- $resourceType := lower .Values.resourceType -}}
{{- if and (not (eq $resourceType "daemonset")) (not (eq $resourceType "statefulset")) (not (eq $resourceType "deployment")) -}}
alloy: resource-type
    Alloy resource type {{ .Values.resourceType }} is not valid, only "daemonset", "statefulset", and "deployment" are allowed
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "grafana-alloy.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "grafana-alloy.validateValues.resourceType" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "grafana-alloy.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.alloy.image }}
{{- include "common.warnings.rollingTag" .Values.configReloader.image }}
{{- end -}}