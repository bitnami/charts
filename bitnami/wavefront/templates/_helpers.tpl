{{/*
Return the proper collector image name
*/}}
{{- define "wavefront.collector.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.collector.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper proxy image name
*/}}
{{- define "wavefront.proxy.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.proxy.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "wavefront.collector.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s-collector" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
