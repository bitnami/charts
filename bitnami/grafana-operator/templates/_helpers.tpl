{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper image name
*/}}
{{- define "grafana-operator.getBaseImage" -}}
{{- $registryName := .image.registry -}}
{{- $repositoryName := .image.repository -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .context.Values.global }}
    {{- if .context.Values.global.imageRegistry }}
        {{- printf "%s/%s" .context.Values.global.imageRegistry $repositoryName -}}
    {{- else -}}
        {{- printf "%s/%s" $registryName $repositoryName -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s" $registryName $repositoryName -}}
{{- end -}}
{{- end -}}


{{/*
Return the proper grafana-operator grafana baseImage name
*/}}
{{- define "grafana-operator.grafana.baseImage" -}}
{{- include "grafana-operator.getBaseImage" (dict "image" .Values.grafana.image "context" $) }}
{{- end -}}

{{/*
Return the grafana-operator grafana plugins init container name if defined or the grafana base image otherwise
*/}}
{{- define "grafana-operator.grafana.pluginsInitContainerImage" -}}
{{- if .Values.grafana.pluginsInitContainerImage.repository }}
{{- include "grafana-operator.getBaseImage" (dict "image" .Values.grafana.pluginsInitContainerImage "context" $) }}
{{- else -}}
{{- include "grafana-operator.grafana.baseImage" . }}
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
