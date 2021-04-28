{{/*
Return the proper wavefront-adapter-for-istio image name
*/}}
{{- define "wfafi.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wfafi.proxy.fullname" -}}
{{- printf "%s-%s" .Release.Name "wavefront-proxy" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "wfafi.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "wfafi.istio.apiVersion" -}}
{{- if .Values.istio.apiVersion -}}
{{- .Values.istio.apiVersion -}}
{{- else -}}
{{ print "config.istio.io/v1alpha2" }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "wfafi.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "wfafi.validateValues.proxy" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Wavefront Adapter for Istio - Wavefront Proxy configuration */}}
{{- define "wfafi.validateValues.proxy" -}}
{{- if and (.Values.wavefront.enabled) (not .Values.wavefront.proxy.enabled) -}}
wavefront-adapter-for-istio: SubchartProxyNotDeployed
    The Wavefront subchart is being deployed without the mandatory Wavefront Proxy instance. Set wavefront.proxy.enabled=true. We recommend the following values:

    wavefront:
      enabled: true
      collector:
        enabled: false
      rbac:
        create: false
      serviceAccount:
        create: false
      proxy:
        enabled: true
{{- end }}

{{- if and .Values.wavefront.enabled .Values.externalProxy.host -}}
wavefront-adapter-for-istio: ConflictingProxies
    The Wavefront subchart is being deployed and an external Wavefront Proxy is set. Select ONLY one of the following options:

    1) Deploy the Wavefront subchart with the Wavefront Proxy. Recommended values:

    wavefront:
      enabled: true
      collector:
        enabled: false
      rbac:
        create: false
      serviceAccount:
        create: false
      proxy:
        enabled: true

    2) Use an existing Wavefront Proxy instance. Set the externalProxy.host and externalProxy.port values

    3) Do not use Wavefront Proxy and connect directly to Wavefront by setting wavefront.enabled=false and not setting the externalProxy.host value
{{- end }}
{{- end -}}
