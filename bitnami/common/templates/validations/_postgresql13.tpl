{{/* vim: set filetype=mustache: */}}
{{/*
Validate PostgreSQL required passwords are not empty.

Usage:
{{ include "common.validations.values.postgresql13.passwords" (dict "secret" "secretName" "subchart" false "context" $) }}
Params:
  - secret - String - Required. Name of the secret where postgresql values are stored, e.g: "postgresql-passwords-secret"
  - subchart - Boolean - Optional. Whether postgresql is used as subchart or not. Default: false
*/}}
{{- define "common.validations.values.postgresql13.passwords" -}}
  {{- $existingSecret := include "common.postgresql.values.auth.existingSecret" . -}}
  {{- $enabled := include "common.postgresql.values.enabled" . -}}
  {{- $valueKeyPostgresqlPassword := include "common.postgresql.values.key.auth.password" . -}}
  {{- $valueKeyPostgresqlReplicationPassword := include "common.postgresql.values.key.auth.replicationPassword" . -}}

  {{- if and (not $existingSecret) (eq $enabled "true") -}}
    {{- $requiredPasswords := list -}}

    {{- $requiredPostgresqlPassword := dict "valueKey" $valueKeyPostgresqlPassword "secret" .secret "field" "postgresql-password" -}}
    {{- $requiredPasswords = append $requiredPasswords $requiredPostgresqlPassword -}}

    {{- $architecture := include "common.postgresql.values.architecture" . -}}
    {{- if (eq $architecture "replication") -}}
        {{- $requiredPostgresqlReplicationPassword := dict "valueKey" $valueKeyPostgresqlReplicationPassword "secret" .secret "field" "postgresql-replication-password" -}}
        {{- $requiredPasswords = append $requiredPasswords $requiredPostgresqlReplicationPassword -}}
    {{- end -}}

    {{- include "common.validations.values.multiple.empty" (dict "required" $requiredPasswords "context" .context) -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for auth.existingSecret.

Usage:
{{ include "common.postgresql.values.auth.existingSecret" (dict "context" $) }}
*/}}
{{- define "common.postgresql.values.auth.existingSecret" -}}
  {{- if .subchart -}}
    {{- .context.Values.postgresql.auth.existingSecret | quote -}}
  {{- else -}}
    {{- .context.Values.auth.existingSecret | quote -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for enabled postgresql.

Usage:
{{ include "common.postgresql.values.enabled" (dict "context" $) }}
*/}}
{{- define "common.postgresql.values.enabled" -}}
  {{- if .subchart -}}
    {{- printf "%v" .context.Values.postgresql.enabled -}}
  {{- else -}}
    {{- printf "%v" (not .context.Values.enabled) -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for the key auth.password.

Usage:
{{ include "common.postgresql.values.key.auth.password" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether postgresql is used as subchart or not. Default: false
*/}}
{{- define "common.postgresql.values.key.auth.password" -}}
  {{- if .subchart -}}
    postgresql.auth.password
  {{- else -}}
    auth.password
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for architecture.

Usage:
{{ include "common.postgresql.values.architecture" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether postgresql is used as subchart or not. Default: false
*/}}
{{- define "common.postgresql.values.architecture" -}}
  {{- if .subchart -}}
    {{- .context.Values.postgresql.architecture -}}
  {{- else -}}
    {{- .context.Values.architecture -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for the key replication.password.

Usage:
{{ include "common.postgresql.values.key.auth.replicationPassword" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether postgresql is used as subchart or not. Default: false
*/}}
{{- define "common.postgresql.values.key.auth.replicationPassword" -}}
  {{- if .subchart -}}
    postgresql.auth.replicationPassword
  {{- else -}}
    auth.replicationPassword
  {{- end -}}
{{- end -}}
