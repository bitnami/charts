{{/*
Return the proper wavefront-hpa-adapter image name
*/}}
{{- define "wfhpaa.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the Service Account to use
*/}}
{{- define "wfhpaa.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
    {{- default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else }}
    {{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "wfhpaa.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "wfhpaa.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "wfhpaa.validateValues.wavefront" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Wavefront HPA Adapter for Kubernetes - Wavefront configuration */}}
{{- define "wfhpaa.validateValues.wavefront" -}}
{{- if not .Values.wavefront.url -}}
wavefront-hpa-adaper: MissingWavefrontURL
   A Wavefront instance URL must be specified. Please set the wavefront.url value
{{- end }}
{{- if not .Values.wavefront.token -}}
wavefront-hpa-adaper: MissingWavefrontToken
   A Wavefront instance Token must be specified. Please set the wavefront.token value
{{- end }}
{{- end -}}
