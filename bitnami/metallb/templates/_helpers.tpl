{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper metallb controller image name
*/}}
{{- define "metallb.controller.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controller.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper metallb speaker image name
*/}}
{{- define "metallb.speaker.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.speaker.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "metallb.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.controller.image .Values.speaker.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the controller service account to use
*/}}
{{- define "metallb.controllerServiceAccountName" -}}
{{- if .Values.controller.serviceAccount.create -}}
    {{ default (printf "%s-controller" (include "common.names.fullname" .)) .Values.controller.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else -}}
    {{ default "default" .Values.controller.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the speaker service account to use
*/}}
{{- define "metallb.speakerServiceAccountName" -}}
{{- if .Values.speaker.serviceAccount.create -}}
    {{ default (printf "%s-speaker" (include "common.names.fullname" .)) .Values.speaker.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else -}}
    {{ default "default" .Values.speaker.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the settings ConfigMap to use.
*/}}
{{- define "metallb.configMapName" -}}
    {{ default ( printf "%s" (include "common.names.fullname" .)) .Values.existingConfigMap | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create the name of the settings Secret to use.
*/}}
{{- define "metallb.secretName" -}}
    {{ default ( printf "%s-memberlist" (include "common.names.fullname" .)) .Values.speaker.secretName | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create the key of the settings Secret to use.
*/}}
{{- define "metallb.secretKey" -}}
    {{ default "secretkey" .Values.speaker.secretKey | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "metallb.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.controller.image }}
{{- include "common.warnings.rollingTag" .Values.speaker.image }}
{{- end -}}
