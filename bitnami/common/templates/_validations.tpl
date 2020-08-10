{{/* vim: set filetype=mustache: */}}
{{/*
Validate values must not be empty.

Usage:
{{- $validateValueConf00 := (dict "valueKey" "path.to.value" "secret" "secretName" "field" "password-00") -}}
{{- $validateValueConf01 := (dict "valueKey" "path.to.value" "secret" "secretName" "field" "password-01") -}}
{{ include "common.validations.values.empty" (dict "required" (list $validateValueConf00 $validateValueConf01) "context" $) }}

Validate value params:
  - valueKey - String - Required. The path to the validating value in the values.yaml, e.g: "mysql.password"
  - secret - String - Optional. Name of the secret where the validating value is generated/stored, e.g: "mysql-passwords-secret"
  - field - String - Optional. Name of the field in the secret data, e.g: "mysql-password"
*/}}
{{- define "common.validations.values.multiple.empty" -}}
  {{- range .required -}}
    {{- include "common.validations.values.single.empty" (dict "valueKey" .valueKey "secret" .secret "field" .field "context" $.context) -}}
  {{- end -}}
{{- end -}}


{{/*
Validate a value must not be empty.

Usage:
{{ include "common.validations.value.empty" (dict "valueKey" "mariadb.password" "secret" "secretName" "field" "my-password" "context" $) }}

Validate value params:
  - valueKey - String - Required. The path to the validating value in the values.yaml, e.g: "mysql.password"
  - secret - String - Optional. Name of the secret where the validating value is generated/stored, e.g: "mysql-passwords-secret"
  - field - String - Optional. Name of the field in the secret data, e.g: "mysql-password"
*/}}
{{- define "common.validations.values.single.empty" -}}
  {{- $valueKeyArray := splitList "." .valueKey -}}
  {{- $value := "" -}}
  {{- $latestObj := $.context.Values -}}
  {{- range $valueKeyArray -}}
    {{- if not $latestObj -}}
      {{- printf "please review the entire path of '%s' exists in values" .valueKey | fail -}}
    {{- end -}}

    {{- $value = ( index $latestObj . ) -}}
    {{- $latestObj = $value -}}
  {{- end -}}

  {{- if not $value -}}
    {{- $varname := "my-value" -}}
    {{- $getCurrentValue := "" -}}
    {{- if and .secret .field -}}
      {{- $varname = include "common.utils.fieldToEnvVar" . -}}
      {{- $getCurrentValue = printf " To get the current value:\n\n        %s\n" (include "common.utils.secret.getvalue" .) -}}
    {{- end -}}

    {{- printf "\n    '%s' must not be empty, please add '--set %s=$%s' to the command.%s" .valueKey .valueKey $varname $getCurrentValue -}}
  {{- end -}}
{{- end -}}

{{/*
Validate a mariadb required password must not be empty.

Usage:
{{ include "common.validations.values.mariadb.passwords" (dict "secret" "secretName" "context" $) }}

Validate value params:
  - secret - String - Required. Name of the secret where mysql values are stored, e.g: "mysql-passwords-secret"
*/}}
{{- define "common.validations.values.mariadb.passwords" -}}
  {{- if and (not .context.Values.mariadb.existingSecret) .context.Values.mariadb.enabled -}}
    {{- $requiredPasswords := list -}}

    {{- $requiredRootMariadbPassword := dict "valueKey" "mariadb.rootUser.password" "secret" .secretName "field" "mariadb-root-password" -}}
    {{- $requiredPasswords = append $requiredPasswords $requiredRootMariadbPassword -}}

    {{- if not (empty .context.Values.mariadb.db.user) -}}
        {{- $requiredMariadbPassword := dict "valueKey" "mariadb.db.password" "secret" .secretName "field" "mariadb-password" -}}
        {{- $requiredPasswords = append $requiredPasswords $requiredMariadbPassword -}}
    {{- end -}}

    {{- if .context.Values.mariadb.replication.enabled -}}
        {{- $requiredReplicationPassword := dict "valueKey" "mariadb.replication.password" "secret" .secretName "field" "mariadb-replication-password" -}}
        {{- $requiredPasswords = append $requiredPasswords $requiredReplicationPassword -}}
    {{- end -}}

    {{- include "common.validations.values.multiple.empty" (dict "required" $requiredPasswords "context" .context) -}}
  {{- end -}}
{{- end -}}

{{/*
Validate a postgresql required password must not be empty.

Usage:
{{ include "common.validations.values.postgresql.passwords" (dict "secret" "secretName" "subchart" false "context" $) }}

Validate value params:
  - secret - String - Required. Name of the secret where postgresql values are stored, e.g: "mysql-passwords-secret"
  - subchart - Boolean - Optional. Whether postgresql is used as subchart or not. Default: false
*/}}
{{- define "common.validations.values.postgresql.passwords" -}}
  {{- $existingSecret := false -}}
  {{- $existingSecretGlobal := false -}}
  {{- if .context.Values.global -}}
    {{- if .context.Values.global.postgresql -}}
      {{- $existingSecretGlobal = .context.Values.global.postgresql.existingSecret -}}
    {{- end -}}
  {{- end -}}
  {{- $enabled := true -}}
  {{- $valueKeyPostgresqlPassword := "postgresqlPassword" -}}
  {{- $enabledReplication := false -}}
  {{- $valueKeyPostgresqlReplicationEnabled := "replication.password" -}}

  {{- if .subchart -}}
    {{- $existingSecret = .context.Values.postgresql.existingSecret -}}
    {{- $existingSecretGlobal = false -}}
    {{- $enabled = .context.Values.postgresql.enabled -}}
    {{- $valueKeyPostgresqlPassword = "postgresql.postgresqlPassword" -}}
    {{- $enabledReplication = .context.Values.postgresql.replication.enabled -}}
    {{- $valueKeyPostgresqlReplicationEnabled = "postgresql.replication.password" -}}
  {{- else -}}
    {{- $existingSecret = .context.Values.existingSecret -}}
    {{- $enabledReplication = .context.Values.replication.enabled -}}
  {{- end -}}

  {{- if and (not $existingSecret) (not $existingSecretGlobal) $enabled -}}
    {{- $requiredPasswords := list -}}

    {{- $requiredPostgresqlPassword := dict "valueKey" $valueKeyPostgresqlPassword "secret" .secret "field" "postgresql-password" -}}
    {{- $requiredPasswords = append $requiredPasswords $requiredPostgresqlPassword -}}

    {{- if $enabledReplication -}}
        {{- $requiredPostgresqlReplicationPassword := dict "valueKey" $valueKeyPostgresqlReplicationEnabled "secret" .secret "field" "postgresql-replication-password" -}}
        {{- $requiredPasswords = append $requiredPasswords $requiredPostgresqlReplicationPassword -}}
    {{- end -}}

    {{- include "common.validations.values.multiple.empty" (dict "required" $requiredPasswords "context" .context) -}}
  {{- end -}}
{{- end -}}
