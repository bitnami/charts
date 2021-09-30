{{/*
Return the proper Apache Geode image name
*/}}
{{- define "geode.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "geode.metrics.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.metrics.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "geode.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "geode.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "geode.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the Apache Geode authentication credentials secret
*/}}
{{- define "geode.secretName" -}}
{{- if .Values.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.auth.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-auth" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a Apache Geode authentication credentials secret object should be created
*/}}
{{- define "geode.createSecret" -}}
{{- if or (and .Values.auth.enabled (empty .Values.auth.existingSecret)) (and .Values.auth.tls.enabled (or (not (empty .Values.auth.tls.keystorePassword)) (not (empty .Values.auth.tls.truststorePassword))))  -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Locator configuration ConfigMap name
*/}}
{{- define "geode.locator.configmapName" -}}
{{- if .Values.locator.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.locator.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-locator-conf" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a ConfigMap object should be created for Locator configuration
*/}}
{{- define "geode.locator.createConfigmap" -}}
{{- if and .Values.locator.configuration (not .Values.locator.existingConfigmap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Locator Log4J configuration ConfigMap name
*/}}
{{- define "geode.locator.log4j.configmapName" -}}
{{- if .Values.locator.existingLog4jConfigMap -}}
    {{- printf "%s" (tpl .Values.locator.existingLog4jConfigMap $) -}}
{{- else -}}
    {{- printf "%s-locator-log4j" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a ConfigMap object should be created for Locator Log4J configuration
*/}}
{{- define "geode.locator.log4j.createConfigmap" -}}
{{- if and .Values.locator.log4j (not .Values.locator.existingLog4jConfigMap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Cache server configuration ConfigMap name
*/}}
{{- define "geode.server.configmapName" -}}
{{- if .Values.server.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.server.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-server-conf" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a ConfigMap object should be created for Cache server configuration
*/}}
{{- define "geode.server.createConfigmap" -}}
{{- if and .Values.server.configuration (not .Values.server.existingConfigmap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Cache server Log4J configuration ConfigMap name
*/}}
{{- define "geode.server.log4j.configmapName" -}}
{{- if .Values.server.existingLog4jConfigMap -}}
    {{- printf "%s" (tpl .Values.server.existingLog4jConfigMap $) -}}
{{- else -}}
    {{- printf "%s-server-log4j" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a ConfigMap object should be created for Cache server Log4J configuration
*/}}
{{- define "geode.server.log4j.createConfigmap" -}}
{{- if and .Values.server.log4j (not .Values.server.existingLog4jConfigMap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations
*/}}
{{- define "geode.ingress.certManagerRequest" -}}
{{ if or (hasKey . "cert-manager.io/cluster-issuer") (hasKey . "cert-manager.io/issuer") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "geode.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "geode.validateValues.tls.components" .) -}}
{{- $messages := append $messages (include "geode.validateValues.tls.secret" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Apache Geode - The list of components for which to enable TLS must be provided when TLS authentication is enabled */}}
{{- define "geode.validateValues.tls.components" -}}
{{- if and .Values.auth.tls.enabled (empty .Values.auth.tls.components) }}
geode: auth.tls.components
    A list of components for which to enable TLS is required
    when TLS authentication is enabled.
{{- end -}}
{{- end -}}

{{/* Validate values of Apache Geode - A secret containing TLS certs must be provided when TLS authentication is enabled */}}
{{- define "geode.validateValues.tls.secret" -}}
{{- if and .Values.auth.tls.enabled (empty .Values.auth.tls.existingSecret) }}
geode: auth.tls.existingSecret
    A secret containing the Apache Geode key stores and trust store is required
    when TLS authentication is enabled.
{{- end -}}
{{- end -}}
