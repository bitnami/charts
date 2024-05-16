{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Supabase Studio Public URL
*/}}
{{- define "supabase.studio.publicURL" -}}
{{- if .Values.studio.publicURL -}}
{{- print .Values.studio.publicURL -}}
{{- else if .Values.studio.ingress.enabled -}}
{{- printf "http://%s" .Values.studio.ingress.hostname -}}
{{- else if (and (eq .Values.studio.service.type "LoadBalancer") .Values.studio.service.loadBalancerIP) -}}
{{- printf "http://%s:%d" .Values.studio.service.loadBalancerIP (int .Values.studio.service.ports.http) -}}
{{- else -}}
{{- printf "http://localhost:%d" (int .Values.kong.service.ports.proxyHttp) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Supabase API Public URL
*/}}
{{- define "supabase.api.publicURL" -}}
{{- if .Values.publicURL -}}
{{- print .Values.publicURL -}}
{{- else if .Values.kong.ingress.enabled -}}
{{- printf "http://%s" .Values.kong.ingress.hostname -}}
{{- else if (and (eq .Values.kong.service.type "LoadBalancer") .Values.kong.service.loadBalancerIP) -}}
{{- printf "http://%s:%d" .Values.kong.service.loadBalancerIP (int .Values.kong.service.ports.proxyHttp) -}}
{{- else -}}
{{- printf "http://localhost:%d" (int .Values.kong.service.ports.proxyHttp) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Supabase auth image name
*/}}
{{- define "supabase.auth.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.auth.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Supabase auth fullname
*/}}
{{- define "supabase.auth.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "auth" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Default configuration ConfigMap name (auth)
*/}}
{{- define "supabase.auth.defaultConfigmapName" -}}
{{- if .Values.auth.existingConfigmap -}}
    {{- print .Values.auth.existingConfigmap -}}
{{- else -}}
    {{- printf "%s-default" (include "supabase.auth.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name (auth)
*/}}
{{- define "supabase.auth.extraConfigmapName" -}}
{{- if .Values.auth.extraConfigExistingConfigmap -}}
    {{- print .Values.auth.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supabase.auth.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Supabase meta image name
*/}}
{{- define "supabase.meta.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.meta.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Supabase meta fullname
*/}}
{{- define "supabase.meta.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "meta" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Default configuration ConfigMap name (meta)
*/}}
{{- define "supabase.meta.defaultConfigmapName" -}}
{{- if .Values.meta.existingConfigmap -}}
    {{- print .Values.meta.existingConfigmap -}}
{{- else -}}
    {{- printf "%s-default" (include "supabase.meta.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name (meta)
*/}}
{{- define "supabase.meta.extraConfigmapName" -}}
{{- if .Values.meta.extraConfigExistingConfigmap -}}
    {{- print .Values.meta.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supabase.meta.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Supabase realtime image name
*/}}
{{- define "supabase.realtime.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.realtime.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Supabase realtime fullname
*/}}
{{- define "supabase.realtime.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "realtime" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Default configuration ConfigMap name (realtime)
*/}}
{{- define "supabase.realtime.defaultConfigmapName" -}}
{{- if .Values.realtime.existingConfigmap -}}
    {{- print .Values.realtime.existingConfigmap -}}
{{- else -}}
    {{- printf "%s-default" (include "supabase.realtime.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name (realtime)
*/}}
{{- define "supabase.realtime.extraConfigmapName" -}}
{{- if .Values.realtime.extraConfigExistingConfigmap -}}
    {{- print .Values.realtime.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supabase.realtime.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Supabase rest image name
*/}}
{{- define "supabase.rest.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.rest.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Supabase rest fullname
*/}}
{{- define "supabase.rest.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "rest" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Default configuration ConfigMap name (rest)
*/}}
{{- define "supabase.rest.defaultConfigmapName" -}}
{{- if .Values.rest.existingConfigmap -}}
    {{- print .Values.rest.existingConfigmap -}}
{{- else -}}
    {{- printf "%s-default" (include "supabase.rest.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name (rest)
*/}}
{{- define "supabase.rest.extraConfigmapName" -}}
{{- if .Values.rest.extraConfigExistingConfigmap -}}
    {{- print .Values.rest.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supabase.rest.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Supabase storage image name
*/}}
{{- define "supabase.storage.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.storage.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Supabase storage fullname
*/}}
{{- define "supabase.storage.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "storage" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Default configuration ConfigMap name (storage)
*/}}
{{- define "supabase.storage.defaultConfigmapName" -}}
{{- if .Values.storage.existingConfigmap -}}
    {{- print .Values.storage.existingConfigmap -}}
{{- else -}}
    {{- printf "%s-default" (include "supabase.storage.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name (storage)
*/}}
{{- define "supabase.storage.extraConfigmapName" -}}
{{- if .Values.storage.extraConfigExistingConfigmap -}}
    {{- print .Values.storage.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supabase.storage.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Supabase studio image name
*/}}
{{- define "supabase.studio.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.studio.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Supabase studio fullname
*/}}
{{- define "supabase.studio.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "studio" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Default configuration ConfigMap name (studio)
*/}}
{{- define "supabase.studio.defaultConfigmapName" -}}
{{- if .Values.studio.existingConfigmap -}}
    {{- print .Values.studio.existingConfigmap -}}
{{- else -}}
    {{- printf "%s-default" (include "supabase.studio.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name
*/}}
{{- define "supabase.studio.extraConfigmapName" -}}
{{- if .Values.studio.extraConfigExistingConfigmap -}}
    {{- print .Values.studio.extraConfigExistingConfigmap -}}
{{- else -}}
    {{- printf "%s-extra" (include "supabase.studio.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper JWT CLI image name
*/}}
{{- define "supabase.jwt-cli.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.jwt.autoGenerate.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper JWT CLI image name
*/}}
{{- define "supabase.kubectl.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.jwt.autoGenerate.kubectlImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper JWT CLI image name
*/}}
{{- define "supabase.createInitJob" -}}
{{- if or .Values.jwt.autoGenerate.forceRun (and (not (and .Values.jwt.secret .Values.jwt.anonKey .Values.jwt.serviceKey)) .Release.IsInstall) -}}
    {{/* We need to run the job if:
        1) We activate the "force" flag
        2) The secret is missing of any of the parameters (only on first install)
    */}}
    {{- true -}}
{{- else -}}
    {{/* Do not return anything */}}
{{- end -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name
*/}}
{{- define "supabase.studio.host" -}}
{{- if .Values.studio.host -}}
    {{- print .Values.studio.host -}}
{{- else if .Values.studio.ingress.enabled -}}
    {{- print .Values.studio.ingress.hostname -}}
{{- else if (eq .Values.studio.service.type "ClusterIP") -}}
    {{- print "http://127.0.0.1" -}}
{{- else if (eq .Values.studio.service.type "LoadBalancer") -}}
    {{- if .Values.studio.service.loadBalancerIP -}}
    {{- print .Values.studio.service.loadBalancerIP -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
JWT credential secret name. Using Release.Name as it is used in subcharts as well
*/}}
{{- define "supabase.jwt.secretName" -}}
{{- coalesce .Values.global.jwt.existingSecret (printf "%s-jwt" .Release.Name) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
JWT credential anon secret key
*/}}
{{- define "supabase.jwt.secretKey" -}}
{{- if .Values.global.jwt.existingSecret -}}
    {{- print .Values.global.jwt.existingSecretKey -}}
{{- else -}}
    {{- print "secret" -}}
{{- end -}}
{{- end -}}

{{/*
Supabase Realtime credential secret name. Using Release.Name as it is used in subcharts as well
*/}}
{{- define "supabase.realtime.secretName" -}}
{{- coalesce .Values.realtime.existingSecret (include "supabase.realtime.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Supabase Realtime credential secret key
*/}}
{{- define "supabase.realtime.secretKey" -}}
{{- if .Values.realtime.existingSecret -}}
    {{- print .Values.realtime.existingSecretKey -}}
{{- else -}}
    {{- print "key-base" -}}
{{- end -}}
{{- end -}}

{{/*
JWT credential anon secret key
*/}}
{{- define "supabase.jwt.anonSecretKey" -}}
{{- if .Values.global.jwt.existingSecret -}}
    {{- print .Values.global.jwt.existingSecretAnonKey -}}
{{- else -}}
    {{- print "anon-key" -}}
{{- end -}}
{{- end -}}

{{/*
JWT credential service secret key
*/}}
{{- define "supabase.jwt.serviceSecretKey" -}}
{{- if .Values.global.jwt.existingSecret -}}
    {{- print .Values.global.jwt.existingSecretServiceKey -}}
{{- else -}}
    {{- print "service-key" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Supabase image name
*/}}
{{- define "supabase.psql.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.psqlImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "supabase.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "supabase.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.auth.image .Values.meta.image .Values.realtime.image .Values.rest.image .Values.storage.image .Values.studio.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "supabase.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "supabase.jwt.serviceAccountName" -}}
{{- if .Values.jwt.autoGenerate.serviceAccount.create -}}
    {{ default (printf "%s-jwt-init" (include "common.names.fullname" .)) .Values.jwt.autoGenerate.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.jwt.autoGenerate.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return postgresql fullname
*/}}
{{- define "supabase.database.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return postgresql fullname
*/}}
{{- define "supabase.kong.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "kong" "chartValues" .Values.kong "context" $) -}}
{{- end -}}

{{/*
Return the PostgreSQL Hostname
*/}}
{{- define "supabase.database.host" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if eq .Values.postgresql.architecture "replication" -}}
        {{- printf "%s-%s" (include "supabase.database.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- print (include "supabase.database.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- print .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return postgresql port
*/}}
{{- define "supabase.database.port" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print .Values.postgresql.service.ports.postgresql -}}
{{- else -}}
    {{- print .Values.externalDatabase.port  -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Secret Name
*/}}
{{- define "supabase.database.secretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.postgresql.auth.existingSecret -}}
    {{- print .Values.postgresql.auth.existingSecret -}}
    {{- else -}}
    {{- print (include "supabase.database.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- print .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "common.names.fullname" .) "externaldb" -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Database Name
*/}}
{{- define "supabase.database.name" -}}
{{- if .Values.postgresql.enabled -}}
    {{/*
        In the supabase-postgres container the database is hardcoded to postgres following
        what's done in upstream
    */}}
    {{- print "postgres" -}}
{{- else -}}
    {{- print .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL User
*/}}
{{- define "supabase.database.user" -}}
{{/* The supabase-postgres container creates a hardcoded supabase_admin user.
     This is because we are using the upstream migration scripts */}}
{{- if .Values.postgresql.enabled }}
    {{- print "supabase_admin" -}}
{{- else -}}
    {{- print .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{- define "supabase.waitForDBInitContainer" -}}
# We need to wait for the postgresql database to be ready in order to start with Supabase.
# As it is a ReplicaSet, we need that all nodes are configured in order to start with
# the application or race conditions can occur
- name: wait-for-db
  image: {{ template "supabase.psql.image" . }}
  imagePullPolicy: {{ .Values.psqlImage.pullPolicy }}
  {{- if .Values.auth.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.auth.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  command:
    - bash
    - -ec
    - |
      #!/bin/bash

      set -o errexit
      set -o nounset
      set -o pipefail

      . /opt/bitnami/scripts/liblog.sh
      . /opt/bitnami/scripts/libvalidations.sh
      . /opt/bitnami/scripts/libpostgresql.sh
      . /opt/bitnami/scripts/postgresql-env.sh

      info "Waiting for host $DATABASE_HOST"
      psql_is_ready() {
          if ! PGCONNECT_TIMEOUT="5" PGPASSWORD="$DATABASE_PASSWORD" psql -U "$DATABASE_USER" -d "$DATABASE_NAME" -h "$DATABASE_HOST" -p "$DATABASE_PORT_NUMBER" -c "SELECT 1"; then
             return 1
          fi
          return 0
      }
      if ! retry_while "debug_execute psql_is_ready"; then
          error "Database not ready"
          exit 1
      fi
      info "Database is ready"
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .Values.psqlImage.debug .Values.diagnosticMode.enabled) | quote }}
    - name: DATABASE_HOST
      value: {{ include "supabase.database.host" . | quote }}
    - name: DATABASE_PORT_NUMBER
      value: {{ include "supabase.database.port" . | quote }}
    - name: DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "supabase.database.secretName" . }}
          key: {{ include "supabase.database.passwordKey" . }}
    - name: DATABASE_USER
      value: {{ include "supabase.database.user" . | quote }}
    - name: DATABASE_NAME
      value: {{ include "supabase.database.name" . | quote }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
{{- end -}}

{{/*
Retrieve key of the postgresql secret
*/}}
{{- define "supabase.database.passwordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "postgres-password" -}}
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

{{/*
Compile all warnings into a single message.
*/}}
{{- define "supabase.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "supabase.validateValues.postgresql" .) -}}
{{- $messages := append $messages (include "supabase.validateValues.secret" .) -}}
{{- $messages := append $messages (include "supabase.validateValues.services" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Supabase - postgresql */}}
{{- define "supabase.validateValues.postgresql" -}}
{{- if and .Values.postgresql.enabled .Values.externalDatabase.host -}}
supabase: postgresql
    You can only use one database.
    Please choose installing a postgresql chart (--set postgresql.enabled=true) or
    using an external database (--set externalDatabase.host)
{{- end -}}
{{- if and (not .Values.postgresql.enabled) (not .Values.externalDatabase.host) -}}
supabase: Nopostgresql
    You did not set any database.
    Please choose installing a postgresql chart (--set postgresql.enabled=true) or
    using an external instance (--set externalDatabase.hosts)
{{- end -}}
{{- end -}}

{{/* Validate values of Supabase - postgresql */}}
{{- define "supabase.validateValues.secret" -}}
{{- if and (or .Values.jwt.anonKey .Values.jwt.serviceKey) (not .Values.jwt.secret)  -}}
supabase: JWT Secret
    You configured the JWT keys but did not set a secret. Please set a secret (--set jwt.secret)
{{- end -}}
{{- end -}}

{{/* Validate values of Supabase - postgresql */}}
{{- define "supabase.validateValues.services" -}}
{{- if not (or .Values.auth.enabled .Values.meta.enabled .Values.realtime.enabled .Values.rest.enabled .Values.storage.enabled .Values.studio.enabled) -}}
supabase: Services
    You did not deploy any of the Supabase services. Please enable at least one service (auth, meta, realtime, rest, storage, studio)
{{- end -}}
{{- end -}}
