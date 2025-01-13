{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Keycloak image name
*/}}
{{- define "keycloak.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper keycloak-config-cli image name
*/}}
{{- define "keycloak.keycloakConfigCli.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.keycloakConfigCli.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the keycloak-config-cli configuration configmap.
*/}}
{{- define "keycloak.keycloakConfigCli.configmapName" -}}
{{- if .Values.keycloakConfigCli.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.keycloakConfigCli.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-keycloak-config-cli-configmap" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created for keycloak-config-cli
*/}}
{{- define "keycloak.keycloakConfigCli.createConfigmap" -}}
{{- if and .Values.keycloakConfigCli.enabled .Values.keycloakConfigCli.configuration (not .Values.keycloakConfigCli.existingConfigmap) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "keycloak.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.keycloakConfigCli.image) "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "keycloak.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "keycloak.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the path Keycloak is hosted on. This looks at httpRelativePath and returns it with a trailing slash. For example:
    / -> / (the default httpRelativePath)
    /auth -> /auth/ (trailing slash added)
    /custom/ -> /custom/ (unchanged)
*/}}
{{- define "keycloak.httpPath" -}}
{{ ternary .Values.httpRelativePath (printf "%s%s" .Values.httpRelativePath "/") (hasSuffix "/" .Values.httpRelativePath) }}
{{- end -}}

{{/*
Return the Keycloak configuration configmap
*/}}
{{- define "keycloak.configmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-configuration" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "keycloak.createConfigmap" -}}
{{- if and .Values.configuration (not .Values.existingConfigmap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database hostname
*/}}
{{- define "keycloak.databaseHost" -}}
{{- if eq .Values.postgresql.architecture "replication" }}
{{- ternary (include "keycloak.postgresql.fullname" .) (tpl .Values.externalDatabase.host $) .Values.postgresql.enabled -}}-primary
{{- else -}}
{{- ternary (include "keycloak.postgresql.fullname" .) (tpl .Values.externalDatabase.host $) .Values.postgresql.enabled -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database port
*/}}
{{- define "keycloak.databasePort" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the Database database name
*/}}
{{- define "keycloak.databaseName" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.auth }}
            {{- coalesce .Values.global.postgresql.auth.database .Values.postgresql.auth.database -}}
        {{- else -}}
            {{- .Values.postgresql.auth.database -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.database -}}
    {{- end -}}
{{- else -}}
    {{- .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database user
*/}}
{{- define "keycloak.databaseUser" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- coalesce .Values.global.postgresql.auth.username .Values.postgresql.auth.username -}}
        {{- else -}}
            {{- .Values.postgresql.auth.username -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.username -}}
    {{- end -}}
{{- else -}}
    {{- .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database encrypted password
*/}}
{{- define "keycloak.databaseSecretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- if .Values.global.postgresql.auth.existingSecret -}}
                {{- tpl .Values.global.postgresql.auth.existingSecret $ -}}
            {{- else -}}
                {{- default (include "keycloak.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "keycloak.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "keycloak.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
{{- else -}}
    {{- default (printf "%s-externaldb" .Release.Name) (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "keycloak.databaseSecretPasswordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- printf "%s" (.Values.postgresql.auth.secretKeys.userPasswordKey | default "password") -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "db-password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "db-password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{- define "keycloak.databaseSecretHostKey" -}}
    {{- if .Values.externalDatabase.existingSecretHostKey -}}
        {{- printf "%s" .Values.externalDatabase.existingSecretHostKey -}}
    {{- else -}}
        {{- print "db-host" -}}
    {{- end -}}
{{- end -}}
{{- define "keycloak.databaseSecretPortKey" -}}
    {{- if .Values.externalDatabase.existingSecretPortKey -}}
        {{- printf "%s" .Values.externalDatabase.existingSecretPortKey -}}
    {{- else -}}
        {{- print "db-port" -}}
    {{- end -}}
{{- end -}}
{{- define "keycloak.databaseSecretUserKey" -}}
    {{- if .Values.externalDatabase.existingSecretUserKey -}}
        {{- printf "%s" .Values.externalDatabase.existingSecretUserKey -}}
    {{- else -}}
        {{- print "db-user" -}}
    {{- end -}}
{{- end -}}
{{- define "keycloak.databaseSecretDatabaseKey" -}}
    {{- if .Values.externalDatabase.existingSecretDatabaseKey -}}
        {{- printf "%s" .Values.externalDatabase.existingSecretDatabaseKey -}}
    {{- else -}}
        {{- print "db-database" -}}
    {{- end -}}
{{- end -}}

{{/*
Return the Keycloak initdb scripts configmap
*/}}
{{- define "keycloak.initdbScriptsCM" -}}
{{- if .Values.initdbScriptsConfigMap -}}
    {{- printf "%s" .Values.initdbScriptsConfigMap -}}
{{- else -}}
    {{- printf "%s-init-scripts" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing the Keycloak admin password
*/}}
{{- define "keycloak.secretName" -}}
{{- $secretName := .Values.auth.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret key that contains the Keycloak admin password
*/}}
{{- define "keycloak.secretKey" -}}
{{- $secretName := .Values.auth.existingSecret -}}
{{- if and $secretName .Values.auth.passwordSecretKey -}}
    {{- printf "%s" .Values.auth.passwordSecretKey -}}
{{- else -}}
    {{- print "admin-password" -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing Keycloak HTTPS/TLS certificates
*/}}
{{- define "keycloak.tlsSecretName" -}}
{{- $secretName := .Values.tls.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing Keycloak HTTPS/TLS keystore and truststore passwords
*/}}
{{- define "keycloak.tlsPasswordsSecretName" -}}
{{- $secretName := .Values.tls.passwordsSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-tls-passwords" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing Keycloak SPI TLS certificates
*/}}
{{- define "keycloak.spiPasswordsSecretName" -}}
{{- $secretName := .Values.spi.passwordsSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-spi-passwords" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret object should be created
*/}}
{{- define "keycloak.createTlsSecret" -}}
{{- if and .Values.tls.enabled .Values.tls.autoGenerated (not .Values.tls.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "keycloak.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "keycloak.validateValues.database" .) -}}
{{- $messages := append $messages (include "keycloak.validateValues.tls" .) -}}
{{- $messages := append $messages (include "keycloak.validateValues.production" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Keycloak - database */}}
{{- define "keycloak.validateValues.database" -}}
{{- if and (not .Values.postgresql.enabled) (not .Values.externalDatabase.host) (and (not .Values.externalDatabase.password) (not .Values.externalDatabase.existingSecret)) -}}
keycloak: database
    You disabled the PostgreSQL sub-chart but did not specify an external PostgreSQL host.
    Either deploy the PostgreSQL sub-chart (--set postgresql.enabled=true),
    or set a value for the external database host (--set externalDatabase.host=FOO)
    and set a value for the external database password (--set externalDatabase.password=BAR)
    or existing secret (--set externalDatabase.existingSecret=BAR).
{{- end -}}
{{- end -}}

{{/* Validate values of Keycloak - TLS enabled */}}
{{- define "keycloak.validateValues.tls" -}}
{{- if and .Values.tls.enabled (not .Values.tls.autoGenerated) (not .Values.tls.existingSecret) }}
keycloak: tls.enabled
    In order to enable TLS, you also need to provide
    an existing secret containing the Keystore and Truststore or
    enable auto-generated certificates.
{{- end -}}
{{- end -}}

{{/* Validate values of Keycloak - Production mode enabled */}}
{{- define "keycloak.validateValues.production" -}}
{{- if and .Values.production (not .Values.tls.enabled) (not (eq .Values.proxy "edge")) (empty .Values.proxyHeaders) -}}
keycloak: production
    In order to enable Production mode, you also need to enable HTTPS/TLS
    using the value 'tls.enabled' and providing an existing secret containing the Keystore and Trustore.
{{- end -}}
{{- end -}}
