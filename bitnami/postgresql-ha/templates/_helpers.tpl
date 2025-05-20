{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Fully qualified app name for PostgreSQL
*/}}
{{- define "postgresql-ha.postgresql" -}}
{{- printf "%s-postgresql" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Fully qualified app name for Pgpool-II
*/}}
{{- define "postgresql-ha.pgpool" -}}
{{- printf "%s-pgpool" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Fully qualified app name for LDAP
*/}}
{{- define "postgresql-ha.ldap" -}}
{{- printf "%s-ldap" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "postgresql-ha.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper PostgreSQL image name
*/}}
{{- define "postgresql-ha.postgresql.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.postgresql.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Pgpool-II image name
*/}}
{{- define "postgresql-ha.pgpool.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.pgpool.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper PostgreSQL Prometheus exporter image name
*/}}
{{- define "postgresql-ha.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper PostgreSQL Prometheus exporter image name
*/}}
{{- define "postgresql-ha.metrics.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.metrics.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "postgresql-ha.image.pullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.postgresql.image .Values.pgpool.image .Values.volumePermissions.image .Values.metrics.image) "context" $) -}}
{{- end -}}

{{/*
Return the PostgreSQL username
*/}}
{{- define "postgresql-ha.postgresqlUsername" -}}
{{- coalesce ((.Values.global).postgresql).username .Values.postgresql.username | default "" -}}
{{- end -}}

{{/*
Return the PostgreSQL database to create
*/}}
{{- define "postgresql-ha.postgresqlDatabase" -}}
{{- coalesce ((.Values.global).postgresql).database .Values.postgresql.database "postgres" -}}
{{- end -}}

{{/*
Return the Pgpool Admin username
*/}}
{{- define "postgresql-ha.pgpoolAdminUsername" -}}
{{- coalesce ((.Values.global).pgpool).adminUsername .Values.pgpool.adminUsername | default "" -}}
{{- end -}}


{{/*
Return the Pgpool-II SR Check username
*/}}
{{- define "postgresql-ha.pgoolSrCheckUsername" -}}
{{- coalesce ((.Values.global).pgpool).srCheckUsername .Values.pgpool.srCheckUsername | default "" -}}
{{- end -}}

{{/*
Get the metrics ConfigMap name.
*/}}
{{- define "postgresql.metricsCM" -}}
{{- printf "%s-metrics" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the PostgreSQL Repmgr username
*/}}
{{- define "postgresql-ha.postgresqlRepmgrUsername" -}}
{{- coalesce ((.Values.global).postgresql).repmgrUsername .Values.postgresql.repmgrUsername | default "" -}}
{{- end -}}

{{/*
Return the database to use for Repmgr
*/}}
{{- define "postgresql-ha.repmgrDatabase" -}}
{{- coalesce ((.Values.global).postgresql).repmgrDatabase .Values.postgresql.repmgrDatabase | default "" -}}
{{- end -}}

{{/*
Return true if the PostgreSQL credential secret has a separate entry for the postgres user
*/}}
{{- define "postgresql-ha.postgresqlSeparatePostgresPassword" -}}
{{- if (include "postgresql-ha.postgresqlCreateSecret" .) -}}
    {{- if not (eq (include "postgresql-ha.postgresqlUsername" .) "postgres") }}
        {{- true -}}
    {{- end -}}
{{- else -}}
    {{- $pgSecret := index (lookup "v1" "Secret" (include "common.names.namespace" .) (include "postgresql-ha.postgresqlSecretName" .)) "data" -}}
    {{- if and $pgSecret (index $pgSecret "postgres-password") -}}
        {{- true -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for PostgreSQL
*/}}
{{- define "postgresql-ha.postgresqlCreateSecret" -}}
{{- if empty (coalesce ((.Values.global).postgresql).existingSecret .Values.postgresql.existingSecret | default "") -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL credentials secret.
*/}}
{{- define "postgresql-ha.postgresqlSecretName" -}}
{{- if include "postgresql-ha.postgresqlCreateSecret" . -}}
    {{- print (include "postgresql-ha.postgresql" .) -}}
{{- else }}
    {{- print (tpl (coalesce ((.Values.global).postgresql).existingSecret .Values.postgresql.existingSecret) .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for Pgpool-II
*/}}
{{- define "postgresql-ha.pgpoolCreateSecret" -}}
{{- if empty (coalesce ((.Values.global).pgpool).existingSecret .Values.pgpool.existingSecret | default "") -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool credentials secret.
*/}}
{{- define "postgresql-ha.pgpoolSecretName" -}}
{{- if include "postgresql-ha.pgpoolCreateSecret" . -}}
    {{- print (include "postgresql-ha.pgpool" .) -}}
{{- else }}
    {{- print (tpl (coalesce ((.Values.global).pgpool).existingSecret .Values.pgpool.existingSecret) .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL configuration ConfigMap
*/}}
{{- define "postgresql-ha.postgresqlConfigurationCM" -}}
{{- if .Values.postgresql.configurationCM -}}
    {{- print (tpl .Values.postgresql.configurationCM .) -}}
{{- else -}}
    {{- printf "%s-configuration" (include "postgresql-ha.postgresql" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL extended configuration ConfigMap
*/}}
{{- define "postgresql-ha.postgresqlExtendedConfCM" -}}
{{- if .Values.postgresql.extendedConfCM -}}
    {{- print (tpl .Values.postgresql.extendedConfCM .) -}}
{{- else -}}
    {{- printf "%s-extended-configuration" (include "postgresql-ha.postgresql" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool-II configuration ConfigMap
*/}}
{{- define "postgresql-ha.pgpoolConfigurationCM" -}}
{{- if .Values.pgpool.configurationCM -}}
    {{- print (tpl .Values.pgpool.configurationCM .) -}}
{{- else -}}
    {{- printf "%s-configuration" (include "postgresql-ha.pgpool" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL initdb scripts ConfigMap
*/}}
{{- define "postgresql-ha.postgresqlInitdbScriptsCM" -}}
{{- if .Values.postgresql.initdbScriptsCM -}}
    {{- print (tpl .Values.postgresql.initdbScriptsCM .) -}}
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
Return the Pgpool-II initdb scripts configmap.
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
{{- coalesce ((.Values.global).ldap).bindpw .Values.ldap.bindpw (randAlphaNum 10) -}}
{{- end -}}

{{/*
Return true if a secret object should be created for LDAP
*/}}
{{- define "postgresql-ha.ldapCreateSecret" -}}
{{- if empty (coalesce ((.Values.global).ldap).existingSecret .Values.ldap.existingSecret | default "") -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the LDAP credentials secret.
*/}}
{{- define "postgresql-ha.ldapSecretName" -}}
{{- if include "postgresql-ha.ldapCreateSecret" . -}}
    {{- print (include "postgresql-ha.ldap" .) -}}
{{- else }}
    {{- print (tpl (coalesce ((.Values.global).ldap).existingSecret .Values.ldap.existingSecret) .) -}}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "postgresql-ha.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.postgresql.image -}}
{{- include "common.warnings.rollingTag" .Values.pgpool.image -}}
{{- include "common.warnings.rollingTag" .Values.metrics.image -}}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image -}}
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
{{- if and .Values.ldap.enabled (or (empty .Values.ldap.uri) (empty .Values.ldap.basedn) (empty .Values.ldap.binddn) (and (empty .Values.ldap.bindpw) (empty .Values.ldap.existingSecret))) -}}
postgresql-ha: LDAP
    Invalid LDAP configuration. When enabling LDAP support, the parameters "ldap.uri",
    "ldap.basedn", "ldap.binddn", and "ldap.bindpw" are mandatory. Please provide them:

    $ helm install {{ .Release.Name }} oci://registry-1.docker.io/bitnamicharts/postgresql-ha \
      --set ldap.enabled=true \
      --set ldap.uri="ldap://my_ldap_server" \
      --set ldap.basedn="dc=example\,dc=org" \
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

    $ helm upgrade {{ .Release.Name }} oci://registry-1.docker.io/bitnamicharts/postgresql-ha \
      --set postgresql.replicaCount=1 \
      --set postgresql.upgradeRepmgrExtension=true
{{- end -}}
{{- end -}}

{{/* Set PostgreSQL PGPASSWORD as environment variable depends on configuration */}}
{{- define "postgresql-ha.pgpassword" -}}
{{- if .Values.postgresql.usePasswordFiles -}}
PGPASSWORD=$(< $POSTGRES_PASSWORD_FILE)
{{- else -}}
PGPASSWORD=$POSTGRES_PASSWORD
{{- end -}}
{{- end -}}

{{/* Set Pgpool-II PGPASSWORD as environment variable depends on configuration */}}
{{- define "postgresql-ha.pgpoolPostgresPassword" -}}
{{- if .Values.postgresql.usePasswordFiles -}}
PGPASSWORD=$(< $PGPOOL_POSTGRES_PASSWORD_FILE)
{{- else -}}
PGPASSWORD=$PGPOOL_POSTGRES_PASSWORD
{{- end -}}
{{- end -}}

{{/*
Return the Pgpool-II secret containing custom users to be added to pool_passwd file.
*/}}
{{- define "postgresql-ha.pgpoolCustomUsersSecretName" -}}
{{- if .Values.pgpool.customUsersSecret -}}
    {{- print (tpl .Values.pgpool.customUsersSecret .) -}}
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
    {{ required "A secret containing TLS certificates is required when TLS is enabled" (tpl .Values.pgpool.tls.certificatesSecret $) }}
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
Get the readiness probe command
*/}}
{{- define "postgresql-ha.readinessProbeCommand" -}}
{{- $block := index .context.Values .component }}
{{- if eq .component "postgresql" -}}
- |
  exec pg_isready -U "postgres" {{- if $block.tls.enabled }} -d "sslcert={{ include "postgresql-ha.postgresql.tlsCert" .context }} sslkey={{ include "postgresql-ha.postgresql.tlsCertKey" .context }}"{{- end }} -h 127.0.0.1 -p {{ $block.containerPorts.postgresql }}
{{- if contains "bitnami/" $block.image.repository }}
  [ -f /opt/bitnami/postgresql/tmp/.initialized ] || [ -f /bitnami/postgresql/.initialized ]
{{- end }}
{{- else -}}
- exec pg_isready -U "postgres" -h 127.0.0.1 -p {{ $block.containerPorts.postgresql }}
{{- end }}
{{- end -}}
