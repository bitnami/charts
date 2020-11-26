{{/* vim: set filetype=mustache: */}}
{{/*
Validate MongoDB required passwords are not empty.

Usage:
{{ include "common.validations.values.mongodb.passwords" (dict "secret" "secretName" "subchart" false "context" $) }}
Params:
  - secret - String - Required. Name of the secret where MongoDB values are stored, e.g: "mongodb-passwords-secret"
  - subchart - Boolean - Optional. Whether MongoDB is used as subchart or not. Default: false
*/}}
{{- define "common.validations.values.mongodb.passwords" -}}
  {{- $existingSecret := include "common.mongodb.values.auth.existingSecret" . -}}
  {{- $enabled := include "common.mongodb.values.enabled" . -}}
  {{- $authPrefix := include "common.mongodb.values.key.auth" . -}}
  {{- $valueKeyRootPassword := printf "%s.rootPassword" $authPrefix -}}
  {{- $valueKeyUsername := printf "%s.username" $authPrefix -}}
  {{- $valueKeyPassword := printf "%s.password" $authPrefix -}}
  {{- $valueKeyReplicaSetKey := printf "%s.replicaSetKey" $authPrefix -}}

  {{- if and (not $existingSecret) (eq $enabled "true") -}}
    {{- $requiredPasswords := list -}}

    {{- $requiredRootPassword := dict "valueKey" $valueKeyRootPassword "secret" .secret "field" "mongodb-root-password" -}}
    {{- $requiredPasswords = append $requiredPasswords $requiredRootPassword -}}

    {{- $valueUsername := include "common.utils.getValueFromKey" (dict "key" $valueKeyUsername "context" .context) }}
    {{- if not (empty $valueUsername) -}}
        {{- $requiredPassword := dict "valueKey" $valueKeyPassword "secret" .secret "field" "mongodb-password" -}}
        {{- $requiredPasswords = append $requiredPasswords $requiredPassword -}}
    {{- end -}}

    {{- $requiredReplicaSetKey := dict "valueKey" $valueKeyReplicaSetKey "secret" .secret "field" "mongodb-replica-set-key" -}}
    {{- $requiredPasswords = append $requiredPasswords $requiredReplicaSetKey -}}

    {{- include "common.validations.values.multiple.empty" (dict "required" $requiredPasswords "context" .context) -}}

  {{- end -}}
{{- end -}}

{{/*
Auxiliar function to get the right value for existingSecret.

Usage:
{{ include "common.mongodb.values.auth.existingSecret" (dict "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether MongoDb is used as subchart or not. Default: false
*/}}
{{- define "common.mongodb.values.auth.existingSecret" -}}
  {{- if .subchart -}}
    {{- .context.Values.mongodb.auth.existingSecret | quote -}}
  {{- else -}}
    {{- .context.Values.auth.existingSecret | quote -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliar function to get the right value for enabled mongodb.

Usage:
{{ include "common.mongodb.values.enabled" (dict "context" $) }}
*/}}
{{- define "common.mongodb.values.enabled" -}}
  {{- if .subchart -}}
    {{- printf "%v" .context.Values.mongodb.enabled -}}
  {{- else -}}
    {{- printf "%v" (not .context.Values.enabled) -}}
  {{- end -}}
{{- end -}}

{{/*
Auxiliar function to get the right value for the key auth

Usage:
{{ include "common.mongodb.values.key.auth" (dict "subchart" "true" "context" $) }}
Params:
  - subchart - Boolean - Optional. Whether MongoDB is used as subchart or not. Default: false
*/}}
{{- define "common.mongodb.values.key.auth" -}}
  {{- if .subchart -}}
    mongodb.auth
  {{- else -}}
    auth
  {{- end -}}
{{- end -}}
