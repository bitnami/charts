{{/* vim: set filetype=mustache: */}}
{{/*
Through error when upgrading using empty passwords values that must not be empty.

Usage:
{{- $requiredPasswordConf00 := (dict "valueKey" "path.to.password00" "secret" "secretName" "field" "password-00") -}}
{{- $requiredPasswordConf01 := (dict "valueKey" "path.to.password01" "secret" "secretName" "field" "password-01") -}}
{{ include "common.errors.upgrade.passwords.empty" (dict "required" (list $requiredPasswordConf00 $requiredPasswordConf01)  "context" $) }}

Required password params:
  - valueKey - String - Required. The path to the required password in the values.yaml, e.g: "mysql.password"
  - secret - String - Required. Name of the secret where the password is generated/stored, e.g: "mysql-passwords-secret"
  - field - String - Required. Name of the field in the secret data, e.g: "mysql-password"
*/}}
{{- define "common.errors.upgrade.passwords.empty" -}}
{{- if .context.Release.IsUpgrade -}}
  {{- $validationErrors := include "common.validations.values.multiple.empty" . -}}

  {{- if $validationErrors -}}
    {{- $errorString := "\nPASSWORDS ERROR: you must provide your current passwords when upgrade the release%s" -}}
    {{- printf $errorString $validationErrors | fail -}}
  {{- end -}}
{{- end -}}
{{- end -}}

