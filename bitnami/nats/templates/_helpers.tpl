{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

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

{{/*
Return true if a NATS configuration secret object should be created
*/}}
{{- define "nats.createSecret" -}}
{{- if and .Values.configuration (not .Values.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "nats.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
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
{{- $messages := append $messages (include "nats.validateValues.jetstream" .) -}}
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

{{/* Validate values of NATS - enabling JetStream requires persistence & statefulsets */}}
{{- define "nats.validateValues.jetstream" -}}
{{- if and .Values.jetstream.enabled (or (ne .Values.resourceType "statefulset") (not .Values.persistence.enabled)) -}}
nats: jetstream
    Invalid configuration selected. Enabling jetstream requires enabling persistence
    and using a "statefulset" (--set persistence.enabled=true,resourceType="statefulset")
{{- end -}}
{{- end -}}
