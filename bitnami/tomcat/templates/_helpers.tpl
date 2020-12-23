{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Tomcat image name
*/}}
{{- define "tomcat.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "tomcat.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "tomcat.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "tomcat.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "tomcat.pvc" -}}
{{- coalesce .Values.persistence.existingClaim (include "common.names.fullname" .) -}}
{{- end -}}
