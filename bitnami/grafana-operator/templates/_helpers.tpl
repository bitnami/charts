{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper grafana-operator grafana baseImage name
*/}}
{{- define "grafana-operator.grafana.baseImage" -}}
{{- $registryName := .Values.grafana.image.registry -}}
{{- $repositoryName := .Values.grafana.image.repository -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s" .Values.global.imageRegistry $repositoryName -}}
    {{- else -}}
        {{- printf "%s/%s" $registryName $repositoryName -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s" $registryName $repositoryName -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper grafana-operator grafana PluginInit baseImage name
*/}}
{{- define "grafana-operator.pluginInit.baseImage" -}}
{{- $registryName := .Values.grafanaPluginInit.image.registry -}}
{{- $repositoryName := .Values.grafanaPluginInit.image.repository -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s" .Values.global.imageRegistry $repositoryName -}}
    {{- else -}}
        {{- printf "%s/%s" $registryName $repositoryName -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s" $registryName $repositoryName -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the grafana-operator service account to use
*/}}
{{- define "grafana-operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create -}}
    {{ default (printf "%s" (include "common.names.fullname" .)) .Values.operator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.operator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Renders a List to a comma separated string values.
Usage:
{{ include "grafana-operator.joinListWithComma" .Values.path.to.the.Value }}
*/}}
{{- define "grafana-operator.joinListWithComma" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}},{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}
