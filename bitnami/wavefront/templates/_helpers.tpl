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
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "wavefront.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.collector.image .Values.proxy.image) "global" .Values.global) -}}
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

{{/*
Compile all warnings into a single message.
*/}}
{{- define "wavefront.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "wavefront.validateValues.clusterName" .) -}}
{{- $messages := append $messages (include "wavefront.validateValues.collector-proxy" .) -}}
{{- $messages := append $messages (include "wavefront.validateValues.api" .) -}}
{{- $messages := append $messages (include "wavefront.validateValues.proxy" .) -}}
{{- $messages := append $messages (include "wavefront.validateValues.instance" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Wavefront - clusterName */}}
{{- define "wavefront.validateValues.clusterName" -}}
{{- if or (not .Values.clusterName) (eq .Values.clusterName "KUBERNETES_CLUSTER_NAME") -}}
wavefront: clusterName
    You must set the value for 'clusterName' to uniquely identify this Kubernetes cluster in Wavefront.
{{- end -}}
{{- end -}}

{{/* Validate values of Wavfront - collector-proxy */}}
{{- define "wavefront.validateValues.collector-proxy" -}}
{{- if and .Values.collector.useProxy (not .Values.proxy.enabled) (not .Values.collector.proxyAddress) -}}
wavefront: collector-proxy
    Collector is set to use proxy but `proxy.enabled` is not true and `collector.proxyAddress` is not provided.
{{- end -}}
{{- end -}}

{{/* Validate values of Wavefront - API */}}
{{- define "wavefront.validateValues.api" -}}
{{- $validUrl := and (.Values.wavefront.url) (ne .Values.wavefront.url "https://YOUR_CLUSTER.wavefront.com") -}}
{{- $validToken := or .Values.wavefront.existingSecret (and (.Values.wavefront.token) (ne .Values.wavefront.token "YOUR_API_TOKEN")) -}}
{{- if and (not .Values.collector.useProxy) (or (not $validUrl) (not $validToken)) -}}
wavefront: api
    Collector is set to use direct ingestion API but `wavefront.url` or `wavefront.token` are not specified.
{{- end -}}
{{- end -}}

{{/* Validate values of Wavefront - Proxy */}}
{{- define "wavefront.validateValues.proxy" -}}
{{- $validUrl := and (.Values.wavefront.url) (ne .Values.wavefront.url "https://YOUR_CLUSTER.wavefront.com") -}}
{{- $validToken := or .Values.wavefront.existingSecret (and (.Values.wavefront.token) (ne .Values.wavefront.token "YOUR_API_TOKEN")) -}}
{{- if and .Values.proxy.enabled (or (not $validUrl) (not $validToken)) }}
wavefront: proxy
    Proxy is enabled but `wavefront.url` or `wavefront.token` are not specified.
{{- end }}
{{- end }}

{{/* Validate values of Wavefront - URL or token */}}
{{- define "wavefront.validateValues.instance" -}}
{{- $validUrl := and (.Values.wavefront.url) (ne .Values.wavefront.url "https://YOUR_CLUSTER.wavefront.com") -}}
{{- $validToken := or .Values.wavefront.existingSecret (and (.Values.wavefront.token) (ne .Values.wavefront.token "YOUR_API_TOKEN")) -}}
{{- if or (not $validUrl) (not $validToken) }}
wavefront: instance
    You did not specify a valid URL or Token for Wavefront.
    If you do not have a Wavefront instance you can get a free trial here

    https://www.wavefront.com/sign-up

    If you already have access to Wavefront please specify your URL and Token then try again.
{{- end }}
{{- end }}
