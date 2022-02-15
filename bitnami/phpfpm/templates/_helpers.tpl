{{/*
Return the proper phpfpm image name
*/}}
{{- define "phpfpm.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.phpfpm.image "global" .Values.global) }}
{{- end -}}


{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "phpfpm.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.phpfpm.image  ) "global" .Values.global) -}}
{{- end -}}


{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations
*/}}
{{- define "phpfpm.ingress.certManagerRequest" -}}
{{ if or (hasKey . "cert-manager.io/cluster-issuer") (hasKey . "cert-manager.io/issuer") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the phpfpm ports map
*/}}
{{- define "phpfpm.ports" -}}
- port: {{ .Values.phpfpm.containerPorts.tcp }}
  protocol: TCP
{{- range .Values.phpfpm.containerExtraPorts }}
- port: {{ include "common.tplvalues.render" (dict "value" .containerPort "context" $) }}
  protocol: TCP
{{- end }}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "phpfpm.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}
