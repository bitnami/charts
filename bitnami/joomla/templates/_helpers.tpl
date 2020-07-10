{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "joomla.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "joomla.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Joomla! image name
*/}}
{{- define "joomla.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "joomla.metrics.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.metrics.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "joomla.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "joomla.storageClass" -}}
{{- include "common.storage.class" ( dict "persistence" .Values.persistence "global" .Values.global ) -}}
{{- end -}}

{{/* Joomla! credential secret name */}}
{{- define "joomla.secretName" -}}
{{- coalesce .Values.existingSecret (include "joomla.fullname" .) -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "joomla.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image -}}
{{- include "common.warnings.rollingTag" .Values.metrics.image -}}
{{- end -}}
