{{/*
Return the proper service name for a subcomponent
Usage:
{{ include "subcomponent.service.name" ( dict "componentName" "name" "context" $ ) }}
*/}}
{{- define "subcomponent.service.name" -}}
{{- printf "%s-%s" .context.Release.Name .componentName -}}
{{- end -}}
