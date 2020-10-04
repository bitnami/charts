{{/* vim: set filetype=mustache: */}}

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


