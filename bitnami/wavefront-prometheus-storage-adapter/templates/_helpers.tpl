{{/*
Return the proper wavefront-prometheus-storage-adapter image name
*/}}
{{- define "wfpsa.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wfpsa.proxy.fullname" -}}
{{- if contains "wavefront" .Release.Name -}}
{{- printf "%s-proxy" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-wavefront-proxy" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "wfpsa.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "wfpsa.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "wfpsa.validateValues.proxy" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Wavefront Prometheus Storage Adapter - Wavefront Proxy configuration */}}
{{- define "wfpsa.validateValues.proxy" -}}
{{- if (not .Values.externalProxy.host) -}}
wavefront-prometheus-storage-adaper: MissingProxy
    The Storage Adapter must connect to a Wavefront Proxy instance. Use an existing Wavefront Proxy instance. Set the externalProxy.host and externalProxy.port values.
{{- end -}}
{{- end -}}
