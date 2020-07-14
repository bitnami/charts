{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "drupal.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "drupal.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Drupal image name
*/}}
{{- define "drupal.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "drupal.metrics.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.metrics.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "drupal.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "drupal.storageClass" -}}
{{- include "common.storage.class" ( dict "persistence" .Values.persistence "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "drupal.deployment.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

{{/* Drupal credential secret name */}}
{{- define "drupal.secretName" -}}
{{- coalesce .Values.existingSecret (include "drupal.fullname" .) -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "drupal.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image -}}
{{- include "common.warnings.rollingTag" .Values.metrics.image -}}
{{- end -}}
