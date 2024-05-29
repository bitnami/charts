{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper nessie image name
*/}}
{{- define "nessie.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper PostgreSQL Client image name
*/}}
{{- define "nessie.psql.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.psqlImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "nessie.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "nessie.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "context" $) -}}
{{- end -}}

{{/*
Return the PostgreSQL Hostname
*/}}
{{- define "nessie.database.host" -}}
{{- if .Values.postgresql.enabled }}
    {{- if eq .Values.postgresql.architecture "replication" }}
        {{- printf "%s-%s" (include "nessie.postgresql.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- print (include "nessie.postgresql.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- print .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Port
*/}}
{{- define "nessie.database.port" -}}
{{- if .Values.postgresql.enabled }}
    {{- print .Values.postgresql.primary.service.ports.postgresql -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Database Name
*/}}
{{- define "nessie.database.name" -}}
{{- if .Values.postgresql.enabled }}
    {{- print .Values.postgresql.auth.database -}}
{{- else -}}
    {{- print .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL User
*/}}
{{- define "nessie.database.user" -}}
{{- if .Values.postgresql.enabled }}
    {{- print .Values.postgresql.auth.username -}}
{{- else -}}
    {{- print .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Secret Name
*/}}
{{- define "nessie.database.secretName" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.postgresql.auth.existingSecret -}}
    {{- print .Values.postgresql.auth.existingSecret -}}
    {{- else -}}
    {{- print (include "nessie.postgresql.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- print .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-%s" (include "common.names.fullname" .) "externaldb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the database password key
*/}}
{{- define "nessie.database.passwordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "password" -}}
{{- else -}}
    {{- print .Values.externalDatabase.existingSecretPasswordKey -}}
{{- end -}}
{{- end -}}

{{/*
Return the database password key
*/}}
{{- define "nessie.database.url" -}}
    {{- printf "jdbc:postgresql://%s:%s/%s" (include "nessie.database.host" .) (include "nessie.database.port" .) (include "nessie.database.name" .) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "nessie.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Extra configuration ConfigMap name
*/}}
{{- define "nessie.configmapName" -}}
{{- if .Values.existingConfigmap -}}
    {{- tpl .Values.existingSecret $ -}}
{{- else -}}
    {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Default configuration Secret name
*/}}
{{- define "nessie.secretName" -}}
{{- if .Values.existingSecret -}}
    {{- tpl .Values.existingSecret $ -}}
{{- else -}}
    {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Convert configuration to their equivalent environment variables. Example:

nessie:
  version_store:
    type: "ROCKSDB"
    persist:
      rocks:
        database_path: /bitnami/nessie

result:

NESSIE_VERSION_STORE_TYPE: ROCKSDB
NESSIE_VERSION_STORE_PERSIST_ROCKS_DATABASE_PATH: /bitnami/nessie

Based on upstream nessie chart: https://github.com/projectnessie/nessie/blob/d32abe58032cd4ff150108095b13fc666488c752/helm/nessie/templates/_helpers.tpl#L73

*/}}
{{- define "nessie.config.convertToEnv" -}}
{{- /* Moving parameters to vars before entering the range */ -}}
{{- $prefix := .prefix -}}
{{- $context := .context -}}
{{- $isSecret := .secret -}}
{{- /* Loop through the values of the map */ -}}
{{- range $key, $val := .config -}}
{{- $varName := "" -}}
{{- $varName = ternary $key (list $prefix $key | join "_") (eq $prefix "") -}}
{{- if kindOf $val | eq "map" -}}
{{- /* If the variable is a map, we call the helper recursively, adding the semi-computed variable name as the prefix */ -}}
{{ include "nessie.config.convertToEnv" (dict "config" $val "prefix" $varName "secret" $isSecret "context" $context) }}
{{- else -}}
{{- /* Base case: We reached to a value that is not a map (sting, integer, boolean), so we can build the variable */ -}}
{{- $finalVarName := $varName | upper | replace "\"" "_" | replace "." "_"  | replace "-" "_" -}}
{{- $finalVal := tpl (toString $val) $context -}}
{{- if $isSecret -}}
{{- /* Apply base64 if it is part of a secret */ -}}
{{- $finalVal = b64enc $finalVal -}}
{{- end }}
{{ $finalVarName }}: {{ $finalVal | quote }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nessie.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return the volume-permissions init container
*/}}
{{- define "nessie.volumePermissionsInitContainer" -}}
- name: volume-permissions
  image: {{ include "nessie.volumePermissions.image"  }}
  imagePullPolicy: {{ default "" .Values.volumePermissions.image.pullPolicy | quote }}
  command:
    - /bin/bash
  args:
    - -ec
    - |
      #!/bin/bash
      mkdir -p {{ .Values.persistence.mountPath }}
      chown {{ .Values.volumePermissions.containerSecurityContext.runAsUser }}:{{ .Values.podSecurityContext.fsGroup }} {{ .Values.persistence.mountPath }}
      find {{ .Values.persistence.mountPath }} -mindepth 1 -maxdepth 1 -not -name ".snapshot" -not -name "lost+found" | xargs chown -R {{ .Values.volumePermissions.containerSecurityContext.runAsUser }}:{{ .Values.podSecurityContext.fsGroup }}
  {{- if .Values.volumePermissions.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.volumePermissions.containerSecurityContext "context" $) | nindent 4 }}
  {{- end }}
  {{- if .Values.volumePermissions.resources }}
  resources: {{- toYaml .Values.volumePermissions.resources | nindent 4 }}
  {{- else if ne .Values.volumePermissions.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.volumePermissions.resourcesPreset) | nindent 4 }}
  {{- end }}
  volumeMounts:
    - name: data
      mountPath: {{ .Values.persistence.mountPath }}
{{- end -}}

{{- define "nessie.waitForDBInitContainer" -}}
# We need to wait for the postgresql database to be ready in order to start with Nessie.
- name: wait-for-db
  image: {{ template "nessie.psql.image" . }}
  imagePullPolicy: {{ .Values.psqlImage.pullPolicy }}
  {{- if .Values.containerSecurityContext.enabled }}
  securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.containerSecurityContext "context" $) | nindent 4 }}
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

      {{- if .Values.usePasswordFile }}
      export DATABASE_PASSWORD="$(< "/bitnami/nessie/secrets/database/QUARKUS_DATASOURCE_POSTGRESQL_PASSWORD")"
      {{- end }}
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
  {{- if .Values.resources }}
  resources: {{- toYaml .Values.resources | nindent 4 }}
  {{- else if ne .Values.resourcesPreset "none" }}
  resources: {{- include "common.resources.preset" (dict "type" .Values.resourcesPreset) | nindent 4 }}
  {{- end }}
  env:
    - name: BITNAMI_DEBUG
      value: {{ ternary "true" "false" (or .Values.psqlImage.debug .Values.diagnosticMode.enabled) | quote }}
    - name: DATABASE_HOST
      value: {{ include "nessie.database.host" . | quote }}
    - name: DATABASE_PORT_NUMBER
      value: {{ include "nessie.database.port" . | quote }}
    {{- if not .Values.usePasswordFile }}
    - name: DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ include "nessie.database.secretName" . }}
          key: {{ include "nessie.database.passwordKey" . }}
    {{- end }}
    - name: DATABASE_USER
      value: {{ include "nessie.database.user" . | quote }}
    - name: DATABASE_NAME
      value: {{ include "nessie.database.name" . | quote }}
  volumeMounts:
    - name: empty-dir
      mountPath: /tmp
      subPath: tmp-dir
    {{- if .Values.usePasswordFile }}
    - name: database-password
      mountPath: /bitnami/nessie/secrets/database
    {{- end }}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "nessie.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "nessie.validateValues.postgresql" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of nessie - At least one storage backend is enabled
*/}}
{{- define "nessie.validateValues.postgresql" -}}
{{- if and (eq .Values.versionStoreType "JDBC_POSTGRESQL") (not .Values.postgresql.enabled) (not .Values.externalDatabase.host) -}}
nessie: postgresql-jdbc
    Version store type is set to JDBC_POSTGRESQL but database is not configured. Please set postgresql.enabled=true or configure the externalDatabase section.
{{- end -}}
{{- end -}}
