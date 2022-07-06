{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name for PostgreSQL Primary objects
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.primary.fullname" -}}
{{- if eq .Values.architecture "replication" }}
    {{- printf "%s-primary" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for PostgreSQL read-only replicas objects
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.readReplica.fullname" -}}
{{- printf "%s-read" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the default FQDN for PostgreSQL primary headless service
We truncate at 63 chars because of the DNS naming spec.
*/}}
{{- define "postgresql.primary.svc.headless" -}}
{{- printf "%s-hl" (include "postgresql.primary.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create the default FQDN for PostgreSQL read-only replicas headless service
We truncate at 63 chars because of the DNS naming spec.
*/}}
{{- define "postgresql.readReplica.svc.headless" -}}
{{- printf "%s-hl" (include "postgresql.readReplica.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Return the proper PostgreSQL image name
*/}}
{{- define "postgresql.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper PostgreSQL metrics image name
*/}}
{{- define "postgresql.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "postgresql.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "postgresql.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the name for a custom user to create
*/}}
{{- define "postgresql.username" -}}
{{- if .Values.global.postgresql.auth.username }}
    {{- .Values.global.postgresql.auth.username -}}
{{- else -}}
    {{- .Values.auth.username -}}
{{- end -}}
{{- end -}}

{{/*
Return the name for a custom database to create
*/}}
{{- define "postgresql.database" -}}
{{- if .Values.global.postgresql.auth.database }}
    {{- .Values.global.postgresql.auth.database -}}
{{- else if .Values.auth.database -}}
    {{- .Values.auth.database -}}
{{- end -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "postgresql.secretName" -}}
{{- if .Values.global.postgresql.auth.existingSecret }}
    {{- printf "%s" (tpl .Values.global.postgresql.auth.existingSecret $) -}}
{{- else if .Values.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.auth.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the replication-password key.
*/}}
{{- define "postgresql.replicationPasswordKey" -}}
{{- if or .Values.global.postgresql.auth.existingSecret .Values.auth.existingSecret }}
    {{- if .Values.global.postgresql.auth.secretKeys.replicationPasswordKey }}
        {{- printf "%s" (tpl .Values.global.postgresql.auth.secretKeys.replicationPasswordKey $) -}}
    {{- else if .Values.auth.secretKeys.replicationPasswordKey -}}
        {{- printf "%s" (tpl .Values.auth.secretKeys.replicationPasswordKey $) -}}
    {{- else -}}
        {{- "replication-password" -}}
    {{- end -}}
{{- else -}}
    {{- "replication-password" -}}
{{- end -}}
{{- end -}}

{{/*
Get the admin-password key.
*/}}
{{- define "postgresql.adminPasswordKey" -}}
{{- if or .Values.global.postgresql.auth.existingSecret .Values.auth.existingSecret }}
    {{- if .Values.global.postgresql.auth.secretKeys.adminPasswordKey }}
        {{- printf "%s" (tpl .Values.global.postgresql.auth.secretKeys.adminPasswordKey $) -}}
    {{- else if .Values.auth.secretKeys.adminPasswordKey -}}
        {{- printf "%s" (tpl .Values.auth.secretKeys.adminPasswordKey $) -}}
    {{- end -}}
{{- else -}}
    {{- "postgres-password" -}}
{{- end -}}
{{- end -}}

{{/*
Get the user-password key.
*/}}
{{- define "postgresql.userPasswordKey" -}}
{{- if or .Values.global.postgresql.auth.existingSecret .Values.auth.existingSecret }}
    {{- if or (empty (include "postgresql.username" .)) (eq (include "postgresql.username" .) "postgres") }}
        {{- printf "%s" (include "postgresql.adminPasswordKey" .) -}}
    {{- else -}}
        {{- if .Values.global.postgresql.auth.secretKeys.userPasswordKey }}
            {{- printf "%s" (tpl .Values.global.postgresql.auth.secretKeys.userPasswordKey $) -}}
        {{- else if .Values.auth.secretKeys.userPasswordKey -}}
            {{- printf "%s" (tpl .Values.auth.secretKeys.userPasswordKey $) -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- ternary "password" "postgres-password" (and (not (empty (include "postgresql.username" .))) (ne (include "postgresql.username" .) "postgres")) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "postgresql.createSecret" -}}
{{- if not (or .Values.global.postgresql.auth.existingSecret .Values.auth.existingSecret) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL service port
*/}}
{{- define "postgresql.service.port" -}}
{{- if .Values.global.postgresql.service.ports.postgresql }}
    {{- .Values.global.postgresql.service.ports.postgresql -}}
{{- else -}}
    {{- .Values.primary.service.ports.postgresql -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL service port
*/}}
{{- define "postgresql.readReplica.service.port" -}}
{{- if .Values.global.postgresql.service.ports.postgresql }}
    {{- .Values.global.postgresql.service.ports.postgresql -}}
{{- else -}}
    {{- .Values.readReplicas.service.ports.postgresql -}}
{{- end -}}
{{- end -}}

{{/*
Get the PostgreSQL primary configuration ConfigMap name.
*/}}
{{- define "postgresql.primary.configmapName" -}}
{{- if .Values.primary.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.primary.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s-configuration" (include "postgresql.primary.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created for PostgreSQL primary with the configuration
*/}}
{{- define "postgresql.primary.createConfigmap" -}}
{{- if and (or .Values.primary.configuration .Values.primary.pgHbaConfiguration) (not .Values.primary.existingConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Get the PostgreSQL primary extended configuration ConfigMap name.
*/}}
{{- define "postgresql.primary.extendedConfigmapName" -}}
{{- if .Values.primary.existingExtendedConfigmap -}}
    {{- printf "%s" (tpl .Values.primary.existingExtendedConfigmap $) -}}
{{- else -}}
    {{- printf "%s-extended-configuration" (include "postgresql.primary.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created for PostgreSQL primary with the extended configuration
*/}}
{{- define "postgresql.primary.createExtendedConfigmap" -}}
{{- if and .Values.primary.extendedConfiguration (not .Values.primary.existingExtendedConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "postgresql.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap should be mounted with PostgreSQL configuration
*/}}
{{- define "postgresql.mountConfigurationCM" -}}
{{- if or .Values.primary.configuration .Values.primary.pgHbaConfiguration .Values.primary.existingConfigmap }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the initialization scripts ConfigMap name.
*/}}
{{- define "postgresql.initdb.scriptsCM" -}}
{{- if .Values.primary.initdb.scriptsConfigMap -}}
    {{- printf "%s" (tpl .Values.primary.initdb.scriptsConfigMap $) -}}
{{- else -}}
    {{- printf "%s-init-scripts" (include "postgresql.primary.fullname" .) -}}
{{- end -}}
{{- end -}}

{/*
Return true if TLS is enabled for LDAP connection
*/}}
{{- define "postgresql.ldap.tls.enabled" -}}
{{- if and (kindIs "string" .Values.ldap.tls) (not (empty .Values.ldap.tls)) }}
    {{- true -}}
{{- else if and (kindIs "map" .Values.ldap.tls) .Values.ldap.tls.enabled }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the readiness probe command
*/}}
{{- define "postgresql.readinessProbeCommand" -}}
{{- $customUser := include "postgresql.username" . }}
- |
{{- if (include "postgresql.database" .) }}
  exec pg_isready -U {{ default "postgres" $customUser | quote }} -d "dbname={{ include "postgresql.database" . }} {{- if .Values.tls.enabled }} sslcert={{ include "postgresql.tlsCert" . }} sslkey={{ include "postgresql.tlsCertKey" . }}{{- end }}" -h 127.0.0.1 -p {{ .Values.containerPorts.postgresql }}
{{- else }}
  exec pg_isready -U {{ default "postgres" $customUser | quote }} {{- if .Values.tls.enabled }} -d "sslcert={{ include "postgresql.tlsCert" . }} sslkey={{ include "postgresql.tlsCertKey" . }}"{{- end }} -h 127.0.0.1 -p {{ .Values.containerPorts.postgresql }}
{{- end }}
{{- if contains "bitnami/" .Values.image.repository }}
  [ -f /opt/bitnami/postgresql/tmp/.initialized ] || [ -f /bitnami/postgresql/.initialized ]
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "postgresql.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "postgresql.validateValues.ldapConfigurationMethod" .) -}}
{{- $messages := append $messages (include "postgresql.validateValues.psp" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Postgresql - If ldap.url is used then you don't need the other settings for ldap
*/}}
{{- define "postgresql.validateValues.ldapConfigurationMethod" -}}
{{- if and .Values.ldap.enabled (and (not (empty .Values.ldap.url)) (not (empty .Values.ldap.server))) }}
postgresql: ldap.url, ldap.server
    You cannot set both `ldap.url` and `ldap.server` at the same time.
    Please provide a unique way to configure LDAP.
    More info at https://www.postgresql.org/docs/current/auth-ldap.html
{{- end -}}
{{- end -}}

{{/*
Validate values of Postgresql - If PSP is enabled RBAC should be enabled too
*/}}
{{- define "postgresql.validateValues.psp" -}}
{{- if and .Values.psp.create (not .Values.rbac.create) }}
postgresql: psp.create, rbac.create
    RBAC should be enabled if PSP is enabled in order for PSP to work.
    More info at https://kubernetes.io/docs/concepts/policy/pod-security-policy/#authorizing-policies
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert file.
*/}}
{{- define "postgresql.tlsCert" -}}
{{- if .Values.tls.autoGenerated }}
    {{- printf "/opt/bitnami/postgresql/certs/tls.crt" -}}
{{- else -}}
    {{- required "Certificate filename is required when TLS in enabled" .Values.tls.certFilename | printf "/opt/bitnami/postgresql/certs/%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the cert key file.
*/}}
{{- define "postgresql.tlsCertKey" -}}
{{- if .Values.tls.autoGenerated }}
    {{- printf "/opt/bitnami/postgresql/certs/tls.key" -}}
{{- else -}}
{{- required "Certificate Key filename is required when TLS in enabled" .Values.tls.certKeyFilename | printf "/opt/bitnami/postgresql/certs/%s" -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "postgresql.tlsCACert" -}}
{{- if .Values.tls.autoGenerated }}
    {{- printf "/opt/bitnami/postgresql/certs/ca.crt" -}}
{{- else -}}
    {{- printf "/opt/bitnami/postgresql/certs/%s" .Values.tls.certCAFilename -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CRL file.
*/}}
{{- define "postgresql.tlsCRL" -}}
{{- if .Values.tls.crlFilename -}}
{{- printf "/opt/bitnami/postgresql/certs/%s" .Values.tls.crlFilename -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "postgresql.createTlsSecret" -}}
{{- if and .Values.tls.autoGenerated (not .Values.tls.certificatesSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the path to the CA cert file.
*/}}
{{- define "postgresql.tlsSecretName" -}}
{{- if .Values.tls.autoGenerated }}
    {{- printf "%s-crt" (include "common.names.fullname" .) -}}
{{- else -}}
    {{ required "A secret containing TLS certificates is required when TLS is enabled" .Values.tls.certificatesSecret }}
{{- end -}}
{{- end -}}
