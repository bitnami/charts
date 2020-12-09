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
        {{- printf "%s" (tpl .Values.auth.existingPasswordSecret $) -}}
    {{- else -}}
        {{- printf "%s" (include "rabbitmq.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Get the erlang secret.
*/}}
{{- define "rabbitmq.secretErlangName" -}}
    {{- if .Values.auth.existingErlangSecret -}}
        {{- printf "%s" (tpl .Values.auth.existingErlangSecret $) -}}
    {{- else -}}
        {{- printf "%s" (include "rabbitmq.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Get the TLS secret.
*/}}
{{- define "rabbitmq.secretTLSName" -}}
    {{- if .Values.auth.tls.existingSecret -}}
        {{- printf "%s" .Values.auth.tls.existingSecret -}}
    {{- else -}}
        {{- printf "%s-certs" (include "rabbitmq.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Get the Ingress TLS secret.
*/}}
{{- define "rabbitmq.ingressSecretTLSName" -}}
    {{- if .Values.ingress.existingSecret -}}
        {{- printf "%s" .Values.ingress.existingSecret -}}
    {{- else -}}
        {{- printf "%s-tls" .Values.ingress.hostname -}}
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
{{- printf "%s" $plugins | replace " " ", " -}}
{{- end -}}

{{/*
Return the number of bytes given a value
following a base 2 o base 10 number system.
Usage:
{{ include "rabbitmq.toBytes" .Values.path.to.the.Value }}
*/}}
{{- define "rabbitmq.toBytes" -}}
{{- $value := int (regexReplaceAll "([0-9]+).*" . "${1}") }}
{{- $unit := regexReplaceAll "[0-9]+(.*)" . "${1}" }}
{{- if eq $unit "Ki" }}
    {{- mul $value 1024 }}
{{- else if eq $unit "Mi" }}
    {{- mul $value 1024 1024 }}
{{- else if eq $unit "Gi" }}
    {{- mul $value 1024 1024 1024 }}
{{- else if eq $unit "Ti" }}
    {{- mul $value 1024 1024 1024 1024 }}
{{- else if eq $unit "Pi" }}
    {{- mul $value 1024 1024 1024 1024 1024 }}
{{- else if eq $unit "Ei" }}
    {{- mul $value 1024 1024 1024 1024 1024 1024 }}
{{- else if eq $unit "K" }}
    {{- mul $value 1000 }}
{{- else if eq $unit "M" }}
    {{- mul $value 1000 1000 }}
{{- else if eq $unit "G" }}
    {{- mul $value 1000 1000 1000 }}
{{- else if eq $unit "T" }}
    {{- mul $value 1000 1000 1000 1000 }}
{{- else if eq $unit "P" }}
    {{- mul $value 1000 1000 1000 1000 1000 }}
{{- else if eq $unit "E" }}
    {{- mul $value 1000 1000 1000 1000 1000 1000 }}
{{- end }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "rabbitmq.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "rabbitmq.validateValues.ldap" .) -}}
{{- $messages := append $messages (include "rabbitmq.validateValues.memoryHighWatermark" .) -}}
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
{{- $serversListLength := len .Values.ldap.servers }}
{{- if or (not (gt $serversListLength 0)) (not (and .Values.ldap.port .Values.ldap.user_dn_pattern)) }}
rabbitmq: LDAP
    Invalid LDAP configuration. When enabling LDAP support, the parameters "ldap.servers",
    "ldap.port", and "ldap. user_dn_pattern" are mandatory. Please provide them:

    $ helm install {{ .Release.Name }} bitnami/rabbitmq \
      --set ldap.enabled=true \
      --set ldap.servers[0]="lmy-ldap-server" \
      --set ldap.port="389" \
      --set user_dn_pattern="cn=${username},dc=example,dc=org"
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of rabbitmq - Memory high watermark
*/}}
{{- define "rabbitmq.validateValues.memoryHighWatermark" -}}
{{- if and (not (eq .Values.memoryHighWatermark.type "absolute")) (not (eq .Values.memoryHighWatermark.type "relative")) }}
rabbitmq: memoryHighWatermark.type
    Invalid Memory high watermark type. Valid values are "absolute" and
    "relative". Please set a valid mode (--set memoryHighWatermark.type="xxxx")
{{- else if and .Values.memoryHighWatermark.enabled (not .Values.resources.limits.memory) (eq .Values.memoryHighWatermark.type "relative") }}
rabbitmq: memoryHighWatermark
    You enabled configuring memory high watermark using a relative limit. However,
    no memory limits were defined at POD level. Define your POD limits as shown below:

    $ helm install {{ .Release.Name }} bitnami/rabbitmq \
      --set memoryHighWatermark.enabled=true \
      --set memoryHighWatermark.type="relative" \
      --set memoryHighWatermark.value="0.4" \
      --set resources.limits.memory="2Gi"

    Altenatively, user an absolute value for the memory memory high watermark :

    $ helm install {{ .Release.Name }} bitnami/rabbitmq \
      --set memoryHighWatermark.enabled=true \
      --set memoryHighWatermark.type="absolute" \
      --set memoryHighWatermark.value="512MB"
{{- end -}}
{{- end -}}
