{{/* vim: set filetype=mustache: */}}


{{/*
Return the proper fluent-bit image name
*/}}
{{- define "fluent-bit.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the deployment
*/}}
{{- define "fluent-bit.fullname" -}}
    {{ printf "%s" (include "common.names.fullname" .) }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "fluent-bit.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "fluent-bit.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "fluent-bit.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the k8s deploy kind
*/}}
{{- define "fluent-bit.kind" -}}
    {{- if .Values.useDaemonset -}}
        {{ printf "%s" "DaemonSet" }}
    {{- else -}}
        {{ printf "%s" "Deployment" }}
    {{- end -}}
{{- end -}}

{{/*
Return the ingress anotation
*/}}
{{- define "fluent-bit.ingress.annotations" -}}
{{ .Values.ingress.annotations | toYaml }}
{{- end -}}

{{/*
Return the ingress hostname
*/}}
{{- define "fluent-bit.ingress.hostname" -}}
{{- .Values.ingress.hostname -}}
{{- end -}}
