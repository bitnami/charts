{{/*
Return the proper Contour Operator image name
*/}}
{{- define "contour-operator.operator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Contour image name
*/}}
{{- define "contour-operator.contour.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.contourImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Envoy image name
*/}}
{{- define "contour-operator.envoy.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.envoyImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "contour-operator.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.contourImage) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "contour-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
