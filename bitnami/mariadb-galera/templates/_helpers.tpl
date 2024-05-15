{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper MariaDB Galera image name
*/}}
{{- define "mariadb-galera.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Prometheus metrics image name
*/}}
{{- define "mariadb-galera.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mariadb-galera.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the secret with MariaDB credentials
*/}}
{{- define "mariadb-galera.secretName" -}}
    {{- if .Values.existingSecret -}}
        {{- printf "%s" .Values.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "common.names.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for MariaDB
*/}}
{{- define "mariadb-galera.createSecret" -}}
{{- if and (not .Values.existingSecret) (not .Values.customPasswordFiles) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Get the configuration ConfigMap name.
*/}}
{{- define "mariadb-galera.configurationCM" -}}
{{- if .Values.configurationConfigMap -}}
{{- printf "%s" (tpl .Values.configurationConfigMap $) -}}
{{- else -}}
{{- printf "%s-configuration" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{ template "mariadb-galera.initdbScriptsCM" . }}
{{/*
Get the initialization scripts ConfigMap name.
*/}}
{{- define "mariadb-galera.initdbScriptsCM" -}}
{{- if .Values.initdbScriptsConfigMap -}}
{{- printf "%s" .Values.initdbScriptsConfigMap -}}
{{- else -}}
{{- printf "%s-init-scripts" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "mariadb-galera.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "mariadb-galera.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "mariadb-galera.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "mariadb-galera.validateValues.rootPassword" .) -}}
{{- $messages := append $messages (include "mariadb-galera.validateValues.password" .) -}}
{{- $messages := append $messages (include "mariadb-galera.validateValues.mariadbBackupPassword" .) -}}
{{- $messages := append $messages (include "mariadb-galera.validateValues.ldap" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of MariaDB Galera - must provide passwords when forced */}}
{{- define "mariadb-galera.validateValues.rootPassword" -}}
{{- if and .Values.rootUser.forcePassword (empty .Values.rootUser.password) (not .Values.existingSecret) -}}
mariadb-galera: rootUser.password
    A MariaDB Database Root Password is required ("rootUser.forcePassword=true" is set)
    Please set a password (--set rootUser.password="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of MariaDB Galera - must provide passwords when forced */}}
{{- define "mariadb-galera.validateValues.password" -}}
{{- if and .Values.db.forcePassword (empty .Values.db.password) (not .Values.existingSecret) -}}
mariadb-galera: db.password
    A MariaDB Database Password is required ("db.forcePassword=true" is set)
    Please set a password (--set db.password="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of MariaDB Galera - must provide passwords when forced */}}
{{- define "mariadb-galera.validateValues.mariadbBackupPassword" -}}
{{- if and .Values.galera.mariabackup.forcePassword (empty .Values.galera.mariabackup.password) (not .Values.existingSecret) -}}
mariadb-galera: galera.mariabackup.password
    A MariaBackup Password is required ("galera.mariabackup.forcePassword=true" is set)
    Please set a password (--set galera.mariabackup.password="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of MariaDB Galera - must provide mandatory LDAP parameters when LDAP is enabled */}}
{{- define "mariadb-galera.validateValues.ldap" -}}
{{- if and .Values.ldap.enabled (or (empty .Values.ldap.uri) (empty .Values.ldap.base) (empty .Values.ldap.binddn) (empty .Values.ldap.bindpw)) -}}
mariadb-galera: LDAP
    Invalid LDAP configuration. When enabling LDAP support, the parameters "ldap.uri",
    "ldap.base", "ldap.binddn", and "ldap.bindpw" are mandatory. Please provide them:

    $ helm install {{ .Release.Name }} oci://registry-1.docker.io/bitnamicharts/mariadb-galera \
      --set ldap.enabled=true \
      --set ldap.uri="ldap://my_ldap_server" \
      --set ldap.base="dc=example,dc=org" \
      --set ldap.binddn="cn=admin,dc=example,dc=org" \
      --set ldap.bindpw="admin"
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert file.
*/}}
{{- define "mariadb-galera.tlsCert" -}}
{{- if and .Values.tls.enabled .Values.tls.autoGenerated }}
    {{- printf "/bitnami/mariadb/certs/tls.crt" -}}
{{- else -}}
    {{- printf "/bitnami/mariadb/certs/%s" .Values.tls.certFilename -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert key file.
*/}}
{{- define "mariadb-galera.tlsCertKey" -}}
{{- if and .Values.tls.enabled .Values.tls.autoGenerated }}
    {{- printf "/bitnami/mariadb/certs/tls.key" -}}
{{- else -}}
    {{- printf "/bitnami/mariadb/certs/%s" .Values.tls.certKeyFilename -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "mariadb-galera.tlsCACert" -}}
{{- if and .Values.tls.enabled .Values.tls.autoGenerated }}
    {{- printf "/bitnami/mariadb/certs/ca.crt" -}}
{{- else -}}
    {{- printf "/bitnami/mariadb/certs/%s" .Values.tls.certCAFilename -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "mariadb-galera.createTlsSecret" -}}
{{- if and .Values.tls.enabled .Values.tls.autoGenerated (not .Values.tls.certificatesSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}


{{/*
Return the path to the CA cert file.
*/}}
{{- define "mariadb-galera.tlsSecretName" -}}
{{- if .Values.tls.enabled }}
{{- if .Values.tls.autoGenerated }}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- else -}}
    {{ required "A secret containing the certificates for the TLS traffic is required when TLS in enabled" .Values.tls.certificatesSecret }}
{{- end -}}
{{- end -}}
{{- end -}}
