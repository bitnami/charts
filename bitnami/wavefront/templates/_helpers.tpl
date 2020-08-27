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

{{/*
Return true if the proxy configmap object should be created
*/}}
{{- define "wavefront.proxy.createConfigmap" -}}
{{- if and .Values.proxy.preprocessor (not .Values.proxy.ExistingConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the proxy configuration configmap name
*/}}
{{- define "wavefront.proxy.configmapName" -}}
{{- if .Values.proxy.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.proxy.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-proxy-preprocessor" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if the collector configmap object should be created
*/}}
{{- define "wavefront.collector.createConfigmap" -}}
{{- if and .Values.collector.enabled (not .Values.collector.ExistingConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the collector configuration configmap name
*/}}
{{- define "wavefront.collector.configmapName" -}}
{{- if .Values.collector.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.collector.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-collector-config" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the token secret name
*/}}
{{- define "wavefront.token.secretName" -}}
{{- if .Values.wavefront.existingSecret -}}
    {{- printf "%s" (tpl .Values.wavefront.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}
