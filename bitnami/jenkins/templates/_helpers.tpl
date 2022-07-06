{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Jenkins image name
*/}}
{{- define "jenkins.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "jenkins.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "jenkins.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
When using Ingress, it will be set to the Ingress hostname.
*/}}
{{- define "jenkins.host" -}}
{{- if .Values.ingress.enabled }}
{{- .Values.ingress.hostname | default "" -}}
{{- else -}}
{{- .Values.jenkinsHost | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "jenkins.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- end -}}
