{{/* vim: set filetype=mustache: */}}
{{/*
Generate secret name.
Usage:
{{ include "common.secrets.name" (dict "existingSecret" .Values.path.to.the.existingSecret "defaultNameSuffix" "mySuffix" "context" $) }}
Params:
defaultNameSuffix - optional is used only if we have several secrets in the same deployment.
*/}}
{{- define "common.secrets.name" -}}
{{- $name := (include "common.names.fullname" .context) -}}

{{- if .defaultNameSuffix -}}
{{- $name = cat $name .defaultNameSuffix -}}
{{- end -}}

{{- with .existingSecret -}}
{{- $name = .name -}}
{{- end -}}

{{- printf "%s" $name -}}
{{- end -}}

{{/*
Generate secret key.
Usage:
{{ include "common.secrets.key" (dict "existingSecret" .Values.path.to.the.existingSecret "key" "keyName") }}
*/}}
{{- define "common.secrets.key" -}}
{{- $key := .key -}}

{{- with .existingSecret -}}
{{- $key = get .keyMapping $.key -}}
{{- end -}}

{{- printf "%s" $key -}}
{{- end -}}
