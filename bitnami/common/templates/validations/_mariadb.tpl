{{/* vim: set filetype=mustache: */}}
{{/*
Validate MariaDB required passwords are not empty.

Usage:
{{ include "common.validations.values.mariadb.passwords" (dict "secret" "secretName" "subchart" false "context" $) }}
Params:
  - secret - String - Required. Name of the secret where MariaDB values are stored, e.g: "mysql-passwords-secret"
  - subchart - Boolean - Optional. Whether MariaDB is used as subchart or not. Default: false
*/}}
{{- define "common.validations.values.mariadb.passwords" -}}
  {{- $existingSecret := include "common.mariadb.values.auth.existingSecret" . -}}
  {{- $existingSecretPasswordKey := include "common.mariadb.values.auth.existingSecretPasswordKey" . -}}
  {{- $existingSecretRootPasswordKey := include "common.mariadb.values.auth.existingSecretRootPasswordKey" . -}}
  {{- $existingSecretReplicationPasswordKey := include "common.mariadb.values.auth.existingSecretReplicationPasswordKey" . -}}
  {{- $enabled := include "common.mariadb.values.enabled" . -}}
  {{- $architecture := include "common.mariadb.values.architecture" . -}}
  {{- $authPrefix := include "common.mariadb.values.key.auth" . -}}
  {{- $valueKeyRootPassword := printf "%s.rootPassword" $authPrefix -}}
  {{- $valueKeyUsername := printf "%s.username" $authPrefix -}}
  {{- $valueKeyPassword := printf "%s.password" $authPrefix -}}
  {{- $valueKeyReplicationPassword := printf "%s.replicationPassword" $authPrefix -}}

  {{- if and (or (not $existingSecret) (eq $existingSecret "\"\"")) (eq $enabled "true") -}}
    {{- $requiredPasswords := list -}}

    {{- $requiredRootPassword := dict "valueKey" $valueKeyRootPassword "secret" .secret "field" $existingSecretRootPasswordKey -}}
    {{- $requiredPasswords = append $requiredPasswords $requiredRootPassword -}}

    {{- $valueUsername := include "common.utils.getValueFromKey" (dict "key" $valueKeyUsername "context" .context) }}
    {{- if not (empty $valueUsername) -}}
        {{- $requiredPassword := dict "valueKey" $valueKeyPassword "secret" .secret "field" $existingSecretPasswordKey -}}
        {{- $requiredPasswords = append $requiredPasswords $requiredPassword -}}
    {{- end -}}

    {{- if (eq $architecture "replication") -}}
        {{- $requiredReplicationPassword := dict "valueKey" $valueKeyReplicationPassword "secret" .secret "field" $existingSecretReplicationPasswordKey -}}
        {{- $requiredPasswords = append $requiredPasswords $requiredReplicationPassword -}}
    {{- end -}}

    {{- include "common.validations.values.multiple.empty" (dict "required" $requiredPasswords "context" .context) -}}

  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for existingSecret.

Usage:
{{ include "common.mariadb.values.auth.existingSecret" (dict "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether MariaDB is used as subchart or not. Default: false
*/}}
{{- define "common.mariadb.values.auth.existingSecret" -}}
  {{- if .subchart -}}
    {{- .context.Values.mariadb.auth.existingSecret | quote -}}
  {{- else -}}
    {{- .context.Values.auth.existingSecret | quote -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for existingSecretPasswordKey.

Usage:
{{ include "common.mariadb.values.auth.existingSecretPasswordKey" (dict "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether MariaDB is used as subchart or not. Default: false
*/}}
{{- define "common.mariadb.values.auth.existingSecretPasswordKey" -}}
  {{- if .subchart -}}
    {{- .context.Values.mariadb.auth.existingSecretPasswordKey | quote -}}
  {{- else -}}
    {{- .context.Values.auth.existingSecretPasswordKey | quote -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for existingSecretRootPasswordKey.

Usage:
{{ include "common.mariadb.values.auth.existingSecretRootPasswordKey" (dict "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether MariaDB is used as subchart or not. Default: false
*/}}
{{- define "common.mariadb.values.auth.existingSecretRootPasswordKey" -}}
  {{- if .subchart -}}
    {{- .context.Values.mariadb.auth.existingSecretRootPasswordKey | quote -}}
  {{- else -}}
    {{- .context.Values.auth.existingSecretRootPasswordKey | quote -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for existingSecretReplicationPasswordKey.

Usage:
{{ include "common.mariadb.values.auth.existingSecretReplicationPasswordKey" (dict "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether MariaDB is used as subchart or not. Default: false
*/}}
{{- define "common.mariadb.values.auth.existingSecretReplicationPasswordKey" -}}
  {{- if .subchart -}}
    {{- .context.Values.mariadb.auth.existingSecretReplicationPasswordKey | quote -}}
  {{- else -}}
    {{- .context.Values.auth.existingSecretReplicationPasswordKey | quote -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for enabled mariadb.

Usage:
{{ include "common.mariadb.values.enabled" (dict "context" $) }}
*/}}
{{- define "common.mariadb.values.enabled" -}}
  {{- if .subchart -}}
    {{- printf "%v" .context.Values.mariadb.enabled -}}
  {{- else -}}
    {{- printf "%v" (not .context.Values.enabled) -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for architecture

Usage:
{{ include "common.mariadb.values.architecture" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether MariaDB is used as subchart or not. Default: false
*/}}
{{- define "common.mariadb.values.architecture" -}}
  {{- if .subchart -}}
    {{- .context.Values.mariadb.architecture -}}
  {{- else -}}
    {{- .context.Values.architecture -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliary function to get the right value for the key auth

Usage:
{{ include "common.mariadb.values.key.auth" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether MariaDB is used as subchart or not. Default: false
*/}}
{{- define "common.mariadb.values.key.auth" -}}
  {{- if .subchart -}}
    mariadb.auth
  {{- else -}}
    auth
  {{- end -}}
{{- end -}}
