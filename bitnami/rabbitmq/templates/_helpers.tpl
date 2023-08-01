{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

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
 Create the name of the service account to use
 */}}
{{- define "rabbitmq.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
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
        {{- printf "%s" (include "common.names.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Get the erlang secret.
*/}}
{{- define "rabbitmq.secretErlangName" -}}
    {{- if .Values.auth.existingErlangSecret -}}
        {{- printf "%s" (tpl .Values.auth.existingErlangSecret $) -}}
    {{- else -}}
        {{- printf "%s" (include "common.names.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Get the TLS secret.
*/}}
{{- define "rabbitmq.tlsSecretName" -}}
    {{- if .Values.auth.tls.existingSecret -}}
        {{- printf "%s" (tpl .Values.auth.tls.existingSecret $) -}}
    {{- else -}}
        {{- printf "%s-certs" (include "common.names.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "rabbitmq.createTlsSecret" -}}
{{- if and .Values.auth.tls.enabled (not .Values.auth.tls.existingSecret) }}
    {{- true -}}
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
{{- $messages := append $messages (include "rabbitmq.validateValues.ingress.tls" .) -}}
{{- $messages := append $messages (include "rabbitmq.validateValues.auth.tls" .) -}}
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
{{- $userDnPattern := coalesce .Values.ldap.user_dn_pattern .Values.ldap.userDnPattern }}
{{- if or (and (not (gt $serversListLength 0)) (empty .Values.ldap.uri)) (and (not $userDnPattern) (not .Values.ldap.basedn)) }}
rabbitmq: LDAP
    Invalid LDAP configuration. When enabling LDAP support, the parameters "ldap.servers" or "ldap.uri" are mandatory
    to configure the connection and "ldap.userDnPattern" or "ldap.basedn" are necessary to lookup the users. Please provide them:
    $ helm install {{ .Release.Name }} oci://registry-1.docker.io/bitnamicharts/rabbitmq \
      --set ldap.enabled=true \
      --set ldap.servers[0]=my-ldap-server" \
      --set ldap.port="389" \
      --set ldap.userDnPattern="cn=${username},dc=example,dc=org"
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

    $ helm install {{ .Release.Name }} oci://registry-1.docker.io/bitnamicharts/rabbitmq \
      --set memoryHighWatermark.enabled=true \
      --set memoryHighWatermark.type="relative" \
      --set memoryHighWatermark.value="0.4" \
      --set resources.limits.memory="2Gi"

    Altenatively, user an absolute value for the memory memory high watermark :

    $ helm install {{ .Release.Name }} oci://registry-1.docker.io/bitnamicharts/rabbitmq \
      --set memoryHighWatermark.enabled=true \
      --set memoryHighWatermark.type="absolute" \
      --set memoryHighWatermark.value="512MB"
{{- end -}}
{{- end -}}

{{/*
Validate values of rabbitmq - TLS configuration for Ingress
*/}}
{{- define "rabbitmq.validateValues.ingress.tls" -}}
{{- if and .Values.ingress.enabled .Values.ingress.tls (not (include "common.ingress.certManagerRequest" ( dict "annotations" .Values.ingress.annotations ))) (not .Values.ingress.selfSigned) (not .Values.ingress.existingSecret) (empty .Values.ingress.extraTls) }}
rabbitmq: ingress.tls
    You enabled the TLS configuration for the default ingress hostname but
    you did not enable any of the available mechanisms to create the TLS secret
    to be used by the Ingress Controller.
    Please use any of these alternatives:
      - Use the `ingress.extraTls` and `ingress.secrets` parameters to provide your custom TLS certificates.
      - Use the `ingress.existingSecret` to provide your custom TLS certificates.
      - Rely on cert-manager to create it by setting the corresponding annotations
      - Rely on Helm to create self-signed certificates by setting `ingress.selfSigned=true`
{{- end -}}
{{- end -}}

{{/*
Validate values of RabbitMQ - Auth TLS enabled
*/}}
{{- define "rabbitmq.validateValues.auth.tls" -}}
{{- if and .Values.auth.tls.enabled (not .Values.auth.tls.autoGenerated) (not .Values.auth.tls.existingSecret) (not .Values.auth.tls.caCertificate) (not .Values.auth.tls.serverCertificate) (not .Values.auth.tls.serverKey) }}
rabbitmq: auth.tls
    You enabled TLS for RabbitMQ but you did not enable any of the available mechanisms to create the TLS secret.
    Please use any of these alternatives:
      - Provide an existing secret containing the TLS certificates using `auth.tls.existingSecret`
      - Provide the plain text certificates using `auth.tls.caCertificate`, `auth.tls.serverCertificate` and `auth.tls.serverKey`.
      - Enable auto-generated certificates using `auth.tls.autoGenerated`.
{{- end -}}
{{- end -}}

{{/*
Get the initialization scripts volume name.
*/}}
{{- define "rabbitmq.initScripts" -}}
{{- printf "%s-init-scripts" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Returns the available value for certain key in an existing secret (if it exists),
otherwise it generates a random value.
*/}}
{{- define "getValueFromSecret" }}
    {{- $len := (default 16 .Length) | int -}}
    {{- $obj := (lookup "v1" "Secret" .Namespace .Name).data -}}
    {{- if $obj }}
        {{- index $obj .Key | b64dec -}}
    {{- else -}}
        {{- randAlphaNum $len -}}
    {{- end -}}
{{- end }}

{{/*
Get the extraConfigurationExistingSecret secret.
*/}}
{{- define "rabbitmq.extraConfiguration" -}}
{{- if not (empty .Values.extraConfigurationExistingSecret) -}}
    {{- include "getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" .Values.extraConfigurationExistingSecret "Length" 10 "Key" "extraConfiguration")  -}}
{{- else -}}
    {{- tpl .Values.extraConfiguration . -}}
{{- end -}}
{{- end -}}

{{/*
Get the TLS.sslOptions.Password secret.
*/}}
{{- define "rabbitmq.tlsSslOptionsPassword" -}}
{{- if not (empty .Values.auth.tls.sslOptionsPassword.password) -}}
    {{- .Values.auth.tls.sslOptionsPassword.password -}}
{{- else -}}
    {{- include "getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" .Values.auth.tls.sslOptionsPassword.existingSecret "Length" 10 "Key" .Values.auth.tls.sslOptionsPassword.key)  -}}
{{- end -}}
{{- end -}}
