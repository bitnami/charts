{{/* vim: set filetype=mustache: */}}

{{/*
Create the name of the envoy service account to use
*/}}
{{- define "envoy.envoyServiceAccountName" -}}
{{- if .Values.contour.serviceAccount.create -}}
    {{ default (printf "%s-envoy" (include "common.names.fullname" .)) .Values.envoy.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.envoy.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the contour service account to use
*/}}
{{- define "contour.contourServiceAccountName" -}}
{{- if .Values.contour.serviceAccount.create -}}
    {{ default (printf "%s-contour" (include "common.names.fullname" .)) .Values.contour.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.contour.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the contour-certgen service account to use
*/}}
{{- define "contour.contourCertGenServiceAccountName" -}}
{{- if .Values.contour.certgen.serviceAccount.create -}}
    {{ default (printf "%s-contour-certgen" (include "common.names.fullname" .)) .Values.contour.certgen.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.contour.certgen.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the settings ConfigMap to use.
*/}}
{{- define "contour.configMapName" -}}
{{- if .Values.configInline -}}
    {{ include "common.names.fullname" . }}
{{- else -}}
    {{ .Values.existingConfigMap }}
{{- end -}}
{{- end -}}
