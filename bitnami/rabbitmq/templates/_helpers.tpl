{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rabbitmq.name" -}}
{{- include "common.names.name" . -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rabbitmq.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rabbitmq.chart" -}}
{{- include "common.names.chart" . -}}
{{- end -}}

{{/*
Return the proper RabbitMQ image name
*/}}
{{- define "rabbitmq.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "rabbitmq.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "rabbitmq.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return podAnnotations
*/}}
{{- define "rabbitmq.podAnnotations" -}}
{{- if .Values.podAnnotations }}
{{ toYaml .Values.podAnnotations }}
{{- end }}
{{- if .Values.metrics.enabled }}
{{ include "common.tplvalues.render" (dict "value" .Values.metrics.podAnnotations "context" $) }}
{{- end }}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "rabbitmq.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "rabbitmq.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "rabbitmq.secretPasswordName" -}}
    {{- if .Values.auth.existingPasswordSecret -}}
        {{- printf "%s" .Values.auth.existingPasswordSecret -}}
    {{- else -}}
        {{- printf "%s" (include "rabbitmq.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Get the erlang secret.
*/}}
{{- define "rabbitmq.secretErlangName" -}}
    {{- if .Values.auth.existingErlangSecret -}}
        {{- printf "%s" .Values.auth.existingErlangSecret -}}
    {{- else -}}
        {{- printf "%s" (include "rabbitmq.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Return the proper RabbitMQ plugin list
*/}}
{{- define "rabbitmq.plugins" -}}
{{- $plugins := .Values.plugins -}}
{{- if .Values.extraPlugins -}}
{{- $plugins = printf "%s %s" $plugins .Values.extraPlugins -}}
{{- end -}}
{{- if .Values.metrics.enabled -}}
{{- $plugins = printf "%s %s" $plugins .Values.metrics.plugins -}}
{{- end -}}
{{- printf "[%s]." $plugins | replace " " ", " -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "rabbitmq.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "rabbitmq.validateValues.ldap" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of rabbitmq - LDAP support
*/}}
{{- define "rabbitmq.validateValues.ldap" -}}
{{- if .Values.ldap.enabled }}
{{- if not (and .Values.ldap.server .Values.ldap.port .Values.ldap.user_dn_pattern) }}
rabbitmq: LDAP
    Invalid LDAP configuration. When enabling LDAP support, the parameters "ldap.server",
    "ldap.port", and "ldap. user_dn_pattern" are mandatory. Please provide them:

    $ helm install {{ .Release.Name }} bitnami/rabbitmq \
      --set ldap.enabled=true \
      --set ldap.server="lmy-ldap-server" \
      --set ldap.port="389" \
      --set user_dn_pattern="cn=${username},dc=example,dc=org"
{{- end -}}
{{- end -}}
{{- end -}}
