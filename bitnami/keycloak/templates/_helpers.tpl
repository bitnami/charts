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
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "keycloak.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.keycloakConfigCli.image) "context" .) -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "keycloak.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" .) -}}
{{- end -}}

{{/*
Create a default fully qualified headless service name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "keycloak.headless.serviceName" -}}
{{- printf "%s-headless" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified headless service name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "keycloak.headless.ispn.serviceName" -}}
{{- printf "%s-headless-ispn-%s" (include "common.names.fullname" .) (replace "." "-" .Chart.AppVersion) | trunc 63 | trimSuffix "-" -}}
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
Return the Keycloak configuration ConfigMap name.
*/}}
{{- define "keycloak.configmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- tpl .Values.existingConfigmap . -}}
{{- else -}}
    {{- printf "%s-configuration" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing the Keycloak admin password
*/}}
{{- define "keycloak.secretName" -}}
{{- if .Values.auth.existingSecret -}}
    {{- tpl .Values.auth.existingSecret . -}}
{{- else -}}
    {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret key that contains the Keycloak admin password
*/}}
{{- define "keycloak.secretKey" -}}
{{- if and .Values.auth.existingSecret .Values.auth.passwordSecretKey -}}
    {{- tpl .Values.auth.passwordSecretKey . -}}
{{- else -}}
    {{- print "admin-password" -}}
{{- end -}}
{{- end -}}

{{/*
Return the keycloak-config-cli configuration ConfigMap name.
*/}}
{{- define "keycloak.keycloakConfigCli.configmapName" -}}
{{- if .Values.keycloakConfigCli.existingConfigmap -}}
    {{- tpl .Values.keycloakConfigCli.existingConfigmap . -}}
{{- else -}}
    {{- printf "%s-keycloak-config-cli-configmap" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database hostname
*/}}
{{- define "keycloak.database.host" -}}
{{- if .Values.postgresql.enabled -}}
    {{- include "keycloak.postgresql.fullname" . -}}{{- if eq .Values.postgresql.architecture "replication" }}-primary{{- end -}}
{{- else -}}
    {{- tpl .Values.externalDatabase.host . -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database port
*/}}
{{- define "keycloak.database.port" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Return the Database database name
*/}}
{{- define "keycloak.database.name" -}}
{{- if .Values.postgresql.enabled }}
    {{- coalesce (((.Values.global).postgresql).auth).database .Values.postgresql.auth.database "postgres" -}}
{{- else -}}
    {{- tpl .Values.externalDatabase.database . -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database user
*/}}
{{- define "keycloak.database.user" -}}
{{- if .Values.postgresql.enabled -}}
    {{- coalesce (((.Values.global).postgresql).auth).username .Values.postgresql.auth.username | default "" -}}
{{- else -}}
    {{- tpl .Values.externalDatabase.user . -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database schema
*/}}
{{- define "keycloak.database.schema" -}}
{{- ternary "public" .Values.externalDatabase.schema .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Return the Database secret name
*/}}
{{- define "keycloak.database.secretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if not (empty (coalesce (((.Values.global).postgresql).auth).existingSecret .Values.postgresql.auth.existingSecret | default "")) -}}
        {{- tpl (coalesce (((.Values.global).postgresql).auth).existingSecret .Values.postgresql.auth.existingSecret) . -}}
    {{- else -}}
        {{- include "keycloak.postgresql.fullname" . -}}
    {{- end -}}
{{- else if not (empty .Values.externalDatabase.existingSecret) -}}
    {{- tpl .Values.externalDatabase.existingSecret . -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database secret key that contains the database user
*/}}
{{- define "keycloak.database.secretUserKey" -}}
{{- default "db-user" .Values.externalDatabase.existingSecretUserKey -}}
{{- end -}}

{{/*
Return the Database secret key that contains the database password
*/}}
{{- define "keycloak.database.secretPasswordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- default "password" .Values.postgresql.auth.secretKeys.userPasswordKey -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- default "db-password" .Values.externalDatabase.existingSecretPasswordKey -}}
{{- else -}}
    {{- print "db-password" -}}
{{- end -}}
{{- end -}}

{{/*
Return the Keycloak initdb scripts ConfigMap name.
*/}}
{{- define "keycloak.initdbScripts.configmapName" -}}
{{- if .Values.initdbScriptsConfigMap -}}
    {{- tpl .Values.initdbScriptsConfigMap . -}}
{{- else -}}
    {{- printf "%s-init-scripts" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing Keycloak HTTPS/TLS certificates
*/}}
{{- define "keycloak.tls.secretName" -}}
{{- if .Values.tls.existingSecret -}}
    {{- tpl .Values.tls.existingSecret . -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing Keycloak HTTPS/TLS keystore and truststore passwords
*/}}
{{- define "keycloak.tls.passwordsSecretName" -}}
{{- if .Values.tls.passwordsSecret -}}
    {{- tpl .Values.tls.passwordsSecret . -}}
{{- else -}}
    {{- printf "%s-tls-passwords" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
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
{{- if and (not .Values.postgresql.enabled) (not .Values.externalDatabase.host) -}}
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
{{- if and .Values.tls.enabled (not .Values.tls.autoGenerated.enabled) (not .Values.tls.existingSecret) }}
keycloak: tls.enabled
    In order to enable TLS, you need to provide a secret with the TLS
    certificates (--set tls.existingSecret=FOO) or enable auto-generated
    TLS certificates (--set tls.autoGenerated.enabled=true).
{{- end -}}
{{- end -}}

{{/* Validate values of Keycloak - Production mode enabled */}}
{{- define "keycloak.validateValues.production" -}}
{{- if and .Values.production (not .Values.tls.enabled) (empty .Values.proxyHeaders) -}}
keycloak: production
    In order to enable Production mode, you also need to enable
    HTTPS/TLS (--set tls.enabled=true) or use proxy headers (--set proxyHeaders=FOO).
{{- end -}}
{{- end -}}
