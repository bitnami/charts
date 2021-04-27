{{/*
Return the proper certManager image name
*/}}
{{- define "certManager.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "certManager.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "certManager.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) }}
{{- end -}}

{{/*
Returns the proper service account name depending if an explicit service account name is set
in the values file. If the name is not set it will default to either common.names.fullname if serviceAccount.enabled
is true or default otherwise.
*/}}
{{- define "certManager.serviceAccountName" -}}
    {{- if .Values.serviceAccount.enabled -}}
        {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
    {{- else -}}
        {{ default "default" .Values.serviceAccount.name }}
    {{- end -}}
{{- end -}}

{{/*
Return the proper certManager webhook image name
*/}}
{{- define "certManager.webhook.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.webhook.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "certManager.webhook.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "certManager.webhook.fullname" -}}
{{- $trimmedName := printf "%s" (include "common.names.fullname" .) | trunc 55 | trimSuffix "-" -}}
{{- printf "%s-webhook" $trimmedName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Returns the proper service account name depending if an explicit service account name is set
in the values file. If the name is not set it will default to either common.names.fullname if serviceAccount.enabled
is true or default otherwise.
*/}}
{{- define "certManager.webhook.serviceAccountName" -}}
    {{- if .Values.webhook.serviceAccount.enabled -}}
        {{- if (empty .Values.webhook.serviceAccount.name) -}}
          {{- $trimmedName := printf "%s" (include "common.names.fullname" .) | trunc 55 | trimSuffix "-" -}}
          {{- printf "%s-webhook" $trimmedName | trunc 63 | trimSuffix "-" -}}
        {{- else -}}
          {{ default "default" .Values.webhook.serviceAccount.name }}
        {{- end -}}
    {{- else -}}
        {{ default "default" .Values.webhook.serviceAccount.name }}
    {{- end -}}
{{- end -}}

{{/*
Return the proper cainjector image name
*/}}
{{- define "certManager.cainjector.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cainjector.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "certManager.cainjector.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "certManager.cainjector.fullname" -}}
{{- $trimmedName := printf "%s" (include "common.names.fullname" .) | trunc 55 | trimSuffix "-" -}}
{{- printf "%s-cainjector" $trimmedName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Returns the proper service account name depending if an explicit service account name is set
in the values file. If the name is not set it will default to either common.names.fullname if serviceAccount.enabled
is true or default otherwise.
*/}}
{{- define "certManager.cainjector.serviceAccountName" -}}
    {{- if .Values.cainjector.serviceAccount.enabled -}}
        {{- if (empty .Values.cainjector.serviceAccount.name) -}}
          {{- $trimmedName := printf "%s" (include "common.names.fullname" .) | trunc 55 | trimSuffix "-" -}}
          {{- printf "%s-cainjector" $trimmedName | trunc 63 | trimSuffix "-" -}}
        {{- else -}}
          {{ default "default" .Values.cainjector.serviceAccount.name }}
        {{- end -}}
    {{- else -}}
        {{ default "default" .Values.cainjector.serviceAccount.name }}
    {{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "certManager.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "certManager.validateValues.foo" .) -}}
{{- $messages := append $messages (include "certManager.validateValues.bar" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

