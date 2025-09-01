{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "versitygw.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.defaultInitContainers.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "versitygw.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.defaultInitContainers.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper versitygw image name
*/}}
{{- define "versitygw.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "versitygw.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the admin credentials secret.
*/}}
{{- define "versitygw.secretName" -}}
{{- if .Values.existingSecret -}}
    {{- tpl .Values.existingSecret $ -}}
{{- else }}
    {{- include "common.names.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
Get the admin credentials secret.
*/}}
{{- define "versitygw.configmapName" -}}
{{- if .Values.existingConfigMap -}}
    {{- tpl .Values.existingConfigMap $ -}}
{{- else }}
    {{- include "common.names.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
Return the Jenkins TLS secret name
*/}}
{{- define "versitygw.tlsSecretName" -}}
{{- if .Values.tls.existingSecret -}}
    {{- tpl .Values.tls.existingSecret $ -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Validate values for versitygw.
*/}}
{{- define "versitygw.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "versitygw.validateValues.backend" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of versitygw - Backend is correct */}}
{{- define "versitygw.validateValues.backend" -}}
{{- $allowedValues := list "posix" "scoutfs" "s3" "other" -}}
{{- if not (has .Values.backend $allowedValues) -}}
versitygw: backend
    Allowed values for `backend` are {{ join "," $allowedValues }}.
{{- end -}}
{{- end -}}
