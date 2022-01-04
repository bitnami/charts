{{/* vim: set filetype=mustache: */}}

{{/*
Fully qualified app name for PostgreSQL
*/}}
{{- define "postgresql-ha.postgresql" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-postgresql" .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-postgresql" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-postgresql" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Fully qualified app name for Pgpool
*/}}
{{- define "postgresql-ha.pgpool" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-pgpool" .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-pgpool" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-pgpool" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Fully qualified app name for LDAP
*/}}
{{- define "postgresql-ha.ldap" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-ldap" .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-ldap" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-ldap" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper PostgreSQL image name
*/}}
{{- define "postgresql-ha.postgresqlImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.postgresqlImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Pgpool image name
*/}}
{{- define "postgresql-ha.pgpoolImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.pgpoolImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper PostgreSQL Prometheus exporter image name
*/}}
{{- define "postgresql-ha.volumePermissionsImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissionsImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper PostgreSQL Prometheus exporter image name
*/}}
{{- define "postgresql-ha.metricsImage" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.metricsImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "postgresql-ha.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.postgresqlImage .Values.pgpoolImage .Values.volumePermissionsImage .Values.metricsImage) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the PostgreSQL username
*/}}
{{- define "postgresql-ha.postgresqlUsername" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.username -}}
            {{- .Values.global.postgresql.username -}}
        {{- else -}}
            {{- .Values.postgresql.username -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.username -}}
    {{- end -}}
{{- else -}}
    {{- .Values.postgresql.username -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL postgres user password
*/}}
{{- define "postgresql-ha.postgresqlPostgresPassword" -}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.postgresPassword -}}
            {{- .Values.global.postgresql.postgresPassword -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.postgresql.postgresPassword (empty .Values.postgresql.postgresPassword) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.postgresql.postgresPassword (empty .Values.postgresql.postgresPassword) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.postgresql.postgresPassword (empty .Values.postgresql.postgresPassword) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if PostgreSQL postgres user password has been provided
*/}}
{{- define "postgresql-ha.postgresqlPasswordProvided" -}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.postgresPassword -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.postgresql.postgresPassword -}}
      {{- true -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL password
*/}}
{{- define "postgresql-ha.postgresqlPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.password }}
            {{- .Values.global.postgresql.password -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.postgresql.password (empty .Values.postgresql.password) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.postgresql.password (empty .Values.postgresql.password) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.postgresql.password (empty .Values.postgresql.password) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool Admin username
*/}}
{{- define "postgresql-ha.pgpoolAdminUsername" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.pgpool -}}
        {{- if .Values.global.pgpool.adminUsername -}}
            {{- .Values.global.pgpool.adminUsername -}}
        {{- else -}}
            {{- .Values.pgpool.adminUsername -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.pgpool.adminUsername -}}
    {{- end -}}
{{- else -}}
    {{- .Values.pgpool.adminUsername -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool Admin password
*/}}
{{- define "postgresql-ha.pgpoolAdminPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.pgpool -}}
        {{- if .Values.global.pgpool.adminPassword -}}
            {{- .Values.global.pgpool.adminPassword -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.pgpool.adminPassword (empty .Values.pgpool.adminPassword) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.pgpool.adminPassword (empty .Values.pgpool.adminPassword) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.pgpool.adminPassword (empty .Values.pgpool.adminPassword) -}}
{{- end -}}
{{- end -}}

{{/*
Get the metrics ConfigMap name.
*/}}
{{- define "postgresql.metricsCM" -}}
{{- printf "%s-metrics" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the PostgreSQL database to create
*/}}
{{- define "postgresql-ha.postgresqlDatabase" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- $postgresqlDatabase := default "postgres" .Values.postgresql.database -}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.database -}}
            {{- default "postgres" .Values.global.postgresql.database -}}
        {{- else -}}
            {{- $postgresqlDatabase -}}
        {{- end -}}
    {{- else -}}
        {{- $postgresqlDatabase -}}
    {{- end -}}
{{- else -}}
    {{- $postgresqlDatabase -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL repmgr username
*/}}
{{- define "postgresql-ha.postgresqlRepmgrUsername" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.repmgrUsername -}}
            {{- .Values.global.postgresql.repmgrUsername -}}
        {{- else -}}
            {{- .Values.postgresql.repmgrUsername -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.repmgrUsername -}}
    {{- end -}}
{{- else -}}
    {{- .Values.postgresql.repmgrUsername -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL repmgr password
*/}}
{{- define "postgresql-ha.postgresqlRepmgrPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.repmgrPassword -}}
            {{- .Values.global.postgresql.repmgrPassword -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.postgresql.repmgrPassword (empty .Values.postgresql.repmgrPassword) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.postgresql.repmgrPassword (empty .Values.postgresql.repmgrPassword) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.postgresql.repmgrPassword (empty .Values.postgresql.repmgrPassword) -}}
{{- end -}}
{{- end -}}

{{/*
Return the database to use for repmgr
*/}}
{{- define "postgresql-ha.repmgrDatabase" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.repmgrDatabase -}}
            {{- .Values.global.postgresql.repmgrDatabase -}}
        {{- else -}}
            {{- .Values.postgresql.repmgrDatabase -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.repmgrDatabase -}}
    {{- end -}}
{{- else -}}
    {{- .Values.postgresql.repmgrDatabase -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for PostgreSQL
*/}}
{{- define "postgresql-ha.postgresqlCreateSecret" -}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.existingSecret -}}
        {{- else if (not .Values.postgresql.existingSecret) -}}
            {{- true -}}
        {{- end -}}
    {{- else if (not .Values.postgresql.existingSecret) -}}
        {{- true -}}
    {{- end -}}
{{- else if (not .Values.postgresql.existingSecret) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL credentials secret.
*/}}
{{- define "postgresql-ha.postgresqlSecretName" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.existingSecret -}}
            {{- printf "%s" (tpl .Values.global.postgresql.existingSecret $) -}}
        {{- else if .Values.postgresql.existingSecret -}}
            {{- printf "%s" (tpl .Values.postgresql.existingSecret $) -}}
        {{- else -}}
            {{- printf "%s" (include "postgresql-ha.postgresql" .) -}}
        {{- end -}}
     {{- else if .Values.postgresql.existingSecret -}}
         {{- printf "%s" (tpl .Values.postgresql.existingSecret $) -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.postgresql" .) -}}
     {{- end -}}
{{- else -}}
     {{- if .Values.postgresql.existingSecret -}}
         {{- printf "%s" (tpl .Values.postgresql.existingSecret $) -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.postgresql" .) -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for Pgpool
*/}}
{{- define "postgresql-ha.pgpoolCreateSecret" -}}
{{- if .Values.global -}}
    {{- if .Values.global.pgpool -}}
        {{- if .Values.global.pgpool.existingSecret -}}
        {{- else if (not .Values.pgpool.existingSecret) -}}
            {{- true -}}
        {{- end -}}
    {{- else if (not .Values.pgpool.existingSecret) -}}
        {{- true -}}
    {{- end -}}
{{- else if (not .Values.pgpool.existingSecret) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool credentials secret.
*/}}
{{- define "postgresql-ha.pgpoolSecretName" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.pgpool -}}
        {{- if .Values.global.pgpool.existingSecret -}}
            {{- printf "%s" .Values.global.pgpool.existingSecret -}}
        {{- else if .Values.pgpool.existingSecret -}}
            {{- printf "%s" .Values.pgpool.existingSecret -}}
        {{- else -}}
            {{- printf "%s" (include "postgresql-ha.pgpool" .) -}}
        {{- end -}}
     {{- else if .Values.pgpool.existingSecret -}}
         {{- printf "%s" .Values.pgpool.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.pgpool" .) -}}
     {{- end -}}
{{- else -}}
     {{- if .Values.pgpool.existingSecret -}}
         {{- printf "%s" .Values.pgpool.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.pgpool" .) -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL configuration configmap.
*/}}
{{- define "postgresql-ha.postgresqlConfigurationCM" -}}
{{- if .Values.postgresql.configurationCM -}}
{{- printf "%s" (tpl .Values.postgresql.configurationCM $) -}}
{{- else -}}
{{- printf "%s-configuration" (include "postgresql-ha.postgresql" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL extended configuration configmap.
*/}}
{{- define "postgresql-ha.postgresqlExtendedConfCM" -}}
{{- if .Values.postgresql.extendedConfCM -}}
{{- printf "%s" (tpl .Values.postgresql.extendedConfCM $) -}}
{{- else -}}
{{- printf "%s-extended-configuration" (include "postgresql-ha.postgresql" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool configuration configmap.
*/}}
{{- define "postgresql-ha.pgpoolConfigurationCM" -}}
{{- if .Values.pgpool.configurationCM -}}
{{- printf "%s" (tpl .Values.pgpool.configurationCM $) -}}
{{- else -}}
{{- printf "%s-configuration" (include "postgresql-ha.pgpool" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL initdb scripts configmap.
*/}}
{{- define "postgresql-ha.postgresqlInitdbScriptsCM" -}}
{{- if .Values.postgresql.initdbScriptsCM -}}
{{- printf "%s" (tpl .Values.postgresql.initdbScriptsCM $) -}}
{{- else -}}
{{- printf "%s-initdb-scripts" (include "postgresql-ha.postgresql" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "postgresql-ha.postgresqlInitdbScriptsSecret" -}}
{{- if .Values.postgresql.initdbScriptsSecret -}}
{{- include "common.tplvalues.render" (dict "value" .Values.postgresql.initdbScriptsSecret "context" $) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool initdb scripts configmap.
*/}}
{{- define "postgresql-ha.pgpoolInitdbScriptsCM" -}}
{{- if .Values.pgpool.initdbScriptsCM -}}
{{- printf "%s" (tpl .Values.pgpool.initdbScriptsCM $) -}}
{{- else -}}
{{- printf "%s-initdb-scripts" (include "postgresql-ha.pgpool" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the pgpool initialization scripts Secret name.
*/}}
{{- define "postgresql-ha.pgpoolInitdbScriptsSecret" -}}
{{- if .Values.pgpool.initdbScriptsSecret -}}
{{- include "common.tplvalues.render" (dict "value" .Values.pgpool.initdbScriptsSecret "context" $) -}}
{{- end -}}
{{- end -}}

{{/*
Return the LDAP bind password
*/}}
{{- define "postgresql-ha.ldapPassword" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.ldap }}
        {{- if .Values.global.ldap.bindpw }}
            {{- .Values.global.ldap.bindpw -}}
        {{- else -}}
            {{- ternary (randAlphaNum 10) .Values.ldap.bindpw (empty .Values.ldap.bindpw) -}}
        {{- end -}}
    {{- else -}}
        {{- ternary (randAlphaNum 10) .Values.ldap.bindpw (empty .Values.ldap.bindpw) -}}
    {{- end -}}
{{- else -}}
    {{- ternary (randAlphaNum 10) .Values.ldap.bindpw (empty .Values.ldap.bindpw) -}}
{{- end -}}
{{- end -}}

{{/*
Return the LDAP credentials secret.
*/}}
{{- define "postgresql-ha.ldapSecretName" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.ldap }}
        {{- if .Values.global.ldap.existingSecret }}
            {{- printf "%s" .Values.global.ldap.existingSecret -}}
        {{- else if .Values.ldap.existingSecret -}}
            {{- printf "%s" .Values.ldap.existingSecret -}}
        {{- else -}}
            {{- printf "%s" (include "postgresql-ha.ldap" .) -}}
        {{- end -}}
     {{- else if .Values.ldap.existingSecret -}}
         {{- printf "%s" .Values.ldap.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.ldap" .) -}}
     {{- end -}}
{{- else -}}
     {{- if .Values.ldap.existingSecret -}}
         {{- printf "%s" .Values.ldap.existingSecret -}}
     {{- else -}}
         {{- printf "%s" (include "postgresql-ha.ldap" .) -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "postgresql-ha.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.postgresqlImage -}}
{{- include "common.warnings.rollingTag" .Values.pgpoolImage -}}
{{- include "common.warnings.rollingTag" .Values.metricsImage -}}
{{- include "common.warnings.rollingTag" .Values.volumePermissionsImage -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "postgresql-ha.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "postgresql-ha.validateValues.nodesHostnames" .) -}}
{{- $messages := append $messages (include "postgresql-ha.validateValues.ldap" .) -}}
{{- $messages := append $messages (include "postgresql-ha.validateValues.ldapPgHba" .) -}}
{{- $messages := append $messages (include "postgresql-ha.validateValues.upgradeRepmgrExtension" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - PostgreSQL nodes hostnames cannot be longer than 128 characters */}}
{{- define "postgresql-ha.validateValues.nodesHostnames" -}}
{{- $postgresqlFullname := include "postgresql-ha.postgresql" . }}
{{- $postgresqlHeadlessServiceName := printf "%s-headless" (include "postgresql-ha.postgresql" .) }}
{{- $nodeHostname := printf "%s-00.%s" $postgresqlFullname $postgresqlHeadlessServiceName }}
{{- if gt (len $nodeHostname) 128 -}}
postgresql-ha: Nodes hostnames
    PostgreSQL nodes hostnames ({{ $nodeHostname }}) exceeds the characters limit for Pgpool: 128.
    Consider using a shorter release name or namespace.
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - must provide mandatory LDAP parameters when LDAP is enabled */}}
{{- define "postgresql-ha.validateValues.ldap" -}}
{{- if and .Values.ldap.enabled (or (empty .Values.ldap.uri) (empty .Values.ldap.base) (empty .Values.ldap.binddn) (and (empty .Values.ldap.bindpw) (empty .Values.ldap.existingSecret))) -}}
postgresql-ha: LDAP
    Invalid LDAP configuration. When enabling LDAP support, the parameters "ldap.uri",
    "ldap.base", "ldap.binddn", and "ldap.bindpw" are mandatory. Please provide them:

    $ helm install {{ .Release.Name }} bitnami/postgresql-ha \
      --set ldap.enabled=true \
      --set ldap.uri="ldap://my_ldap_server" \
      --set ldap.base="dc=example\,dc=org" \
      --set ldap.binddn="cn=admin\,dc=example\,dc=org" \
      --set ldap.bindpw="admin"
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - PostgreSQL HBA configuration must trust every user when LDAP is enabled */}}
{{- define "postgresql-ha.validateValues.ldapPgHba" -}}
{{- if and .Values.ldap.enabled (not .Values.postgresql.pgHbaTrustAll) }}
postgresql-ha: LDAP & pg_hba.conf
    PostgreSQL HBA configuration must trust every user when LDAP is enabled.
    Please configure HBA to trust every user (--set postgresql.pgHbaTrustAll=true)
{{- end -}}
{{- end -}}

{{/* Validate values of PostgreSQL HA - There must be an unique replica when upgrading repmgr extension */}}
{{- define "postgresql-ha.validateValues.upgradeRepmgrExtension" -}}
{{- $postgresqlReplicaCount := int .Values.postgresql.replicaCount }}
{{- if and .Values.postgresql.upgradeRepmgrExtension (gt $postgresqlReplicaCount 1) }}
postgresql-ha: Upgrade repmgr extension
    There must be only one replica when upgrading repmgr extension:

    $ helm upgrade {{ .Release.Name }} bitnami/postgresql-ha \
      --set postgresql.replicaCount=1 \
      --set postgresql.upgradeRepmgrExtension=true
{{- end -}}
{{- end -}}

{{/* Set PGPASSWORD as environment variable depends on configuration */}}
{{- define "postgresql-ha.pgpassword" -}}
{{- if .Values.postgresql.usePasswordFile -}}
PGPASSWORD=$(< $POSTGRES_PASSWORD_FILE)
{{- else -}}
PGPASSWORD=$POSTGRES_PASSWORD
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool secret containing custom users to be added to
pool_passwd file.
*/}}
{{- define "postgresql-ha.pgpoolCustomUsersSecretName" -}}
{{- if .Values.pgpool.customUsersSecret -}}
{{- printf "%s" (tpl .Values.pgpool.customUsersSecret $) -}}
{{- else -}}
{{- printf "%s-custom-users" (include "postgresql-ha.pgpool" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert file.
*/}}
{{- define "postgresql-ha.pgpool.tlsCert" -}}
{{- if and .Values.pgpool.tls.enabled .Values.pgpool.tls.autoGenerated }}
    {{- printf "/opt/bitnami/pgpool/certs/tls.crt" -}}
{{- else -}}
{{- required "Certificate filename is required when TLS in enabled" .Values.pgpool.tls.certFilename | printf "/opt/bitnami/pgpool/certs/%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert key file.
*/}}
{{- define "postgresql-ha.pgpool.tlsCertKey" -}}
{{- if and .Values.pgpool.tls.enabled .Values.pgpool.tls.autoGenerated }}
    {{- printf "/opt/bitnami/pgpool/certs/tls.key" -}}
{{- else -}}
    {{- required "Certificate Key filename is required when TLS in enabled" .Values.pgpool.tls.certKeyFilename | printf "/opt/bitnami/pgpool/certs/%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "postgresql-ha.pgpool.tlsCACert" -}}
{{- if and .Values.pgpool.tls.enabled .Values.pgpool.tls.autoGenerated }}
    {{- printf "/opt/bitnami/pgpool/certs/ca.crt" -}}
{{- else -}}
    {{- printf "/opt/bitnami/pgpool/certs/%s" .Values.pgpool.tls.certCAFilename -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "postgresql-ha.createTlsSecret" -}}
{{- if and .Values.pgpool.tls.enabled .Values.pgpool.tls.autoGenerated (not .Values.pgpool.tls.certificatesSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "postgresql-ha.tlsSecretName" -}}
{{- if .Values.pgpool.tls.enabled }}
{{- if .Values.pgpool.tls.autoGenerated }}
    {{- printf "%s-crt" (include "postgresql-ha.pgpool" .) -}}
{{- else -}}
    {{ required "A secret containing TLS certificates is required when TLS is enabled" .Values.pgpool.tls.certificatesSecret }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if PostgreSQL postgres existingSecret has been provided
*/}}
{{- define "postgresql-ha.postgresql.existingSecretProvided" -}}
{{- if .Values.global -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.existingSecret -}}
            {{- true -}}
        {{- else if .Values.postgresql.existingSecret -}}
            {{- true -}}
        {{- end -}}
    {{- else if .Values.postgresql.existingSecret -}}
        {{- true -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.postgresql.existingSecret -}}
      {{- true -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if PostgreSQL pgpool existingSecret has been provided
*/}}
{{- define "postgresql-ha.pgpool.existingSecretProvided" -}}
{{- if .Values.global -}}
    {{- if .Values.global.pgpool -}}
        {{- if .Values.global.pgpool.existingSecret -}}
            {{- true -}}
        {{- else if .Values.pgpool.existingSecret -}}
            {{- true -}}
        {{- end -}}
    {{- else if .Values.pgpool.existingSecret -}}
        {{- true -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.pgpool.existingSecret -}}
      {{- true -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert file.
*/}}
{{- define "postgresql-ha.postgresql.tlsCert" -}}
{{- required "Certificate filename is required when TLS in enabled" .Values.postgresql.tls.certFilename | printf "/opt/bitnami/postgresql/certs/%s" -}}
{{- end -}}

{{/*
Return the path to the cert key file.
*/}}
{{- define "postgresql-ha.postgresql.tlsCertKey" -}}
{{- required "Certificate Key filename is required when TLS in enabled" .Values.postgresql.tls.certKeyFilename | printf "/opt/bitnami/postgresql/certs/%s" -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "postgresql-ha.postgresql.tlsCACert" -}}
{{- printf "/opt/bitnami/postgresql/certs/%s" .Values.postgresql.tls.certCAFilename -}}
{{- end -}}

