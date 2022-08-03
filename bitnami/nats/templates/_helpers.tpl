{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Nats image name
*/}}
{{- define "nats.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "nats.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "nats.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create a random alphanumeric password string.
We prepend a random letter to the string to avoid password validation errors
*/}}
{{- define "nats.randomPassword" -}}
{{- randAlpha 1 -}}{{- randAlphaNum 9 -}}
{{- end -}}

{{/* Get current password or generate randomPassword */}}
{{- define "nats.password" }}
{{- if .Values.auth.password }}
{{- .Values.auth.password }}
{{- else -}}
{{- $secrets := (lookup "v1" "Secret" .Release.Namespace (include "common.names.fullname" .)).data -}}
{{- if hasKey $secrets "user-password" }}
{{- index $secrets "user-password" | b64dec -}}
{{- else -}}
{{- include "nats.randomPassword" . -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/* Get current cluster password or generate randomPassword */}}
{{- define "nats.clusterPassword" }}
{{- if .Values.cluster.auth.password }}
{{- .Values.cluster.auth.password }}
{{- else -}}
{{- $secrets := (lookup "v1" "Secret" .Release.Namespace (include "common.names.fullname" .)).data -}}
{{- if hasKey $secrets "cluster-password" }}
{{- index $secrets "cluster-password" | b64dec -}}
{{- else -}}
{{- include "nats.randomPassword" . -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Return true if a NATS configuration secret object should be created
*/}}
{{- define "nats.createSecret" -}}
{{- if not .Values.existingSecret }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the NATS configuration secret name
*/}}
{{- define "nats.secretName" -}}
{{- if .Values.existingSecret }}
    {{- printf "%s" (tpl .Values.existingSecret .) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "nats.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "nats.validateValues.resourceType" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of NATS - must provide a valid resourceType ("deployment" or "statefulset") */}}
{{- define "nats.validateValues.resourceType" -}}
{{- if and (ne .Values.resourceType "deployment") (ne .Values.resourceType "statefulset") -}}
nats: resourceType
    Invalid resourceType selected. Valid values are "deployment" and
    "statefulset". Please set a valid mode (--set resourceType="xxxx")
{{- end -}}
{{- end -}}
