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
{{- printf "%s-%s" .Release.Name "wavefront-proxy" | trunc 63 | trimSuffix "-" -}}
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
{{- if and (not .Values.wavefront.enabled) (not .Values.externalProxy.host) -}}
wavefront-prometheus-storage-adaper: MissingProxy
    The Storage Adapter must connect to a Wavefront Proxy instance. Use one of the following options:

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
{{- end -}}

{{- if and (.Values.wavefront.enabled) (not .Values.wavefront.proxy.enabled) -}}
wavefront-prometheus-storage-adaper: SubchartProxyNotDeployed
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
wavefront-prometheus-storage-adaper: ConflictingProxies
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
{{- end }}
{{- end -}}
