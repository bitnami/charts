{{/* vim: set filetype=mustache: */}}
{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "contour.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if .Values.contour.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.contour.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if .Values.contour.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.contour.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "envoy.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if .Values.envoy.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.envoy.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if .Values.envoy.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.envoy.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}


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
