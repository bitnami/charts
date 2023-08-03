{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Kubernetes standard labels
{{ include "common.labels.standard" (dict "customLabels" .Values.commonLabels "context" $) -}}
*/}}
{{- define "common.labels.standard" -}}
{{- $customLabels := default (dict) .customLabels -}}
{{- if not (hasKey $customLabels "app.kubernetes.io/name") }}
app.kubernetes.io/name: {{ include "common.names.name" .context }}
{{- end }}
{{- if not (hasKey $customLabels "helm.sh/chart") }}
helm.sh/chart: {{ include "common.names.chart" .context }}
{{- end }}
{{- if not (hasKey $customLabels "app.kubernetes.io/instance") }}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- end }}
{{- if not (hasKey $customLabels "app.kubernetes.io/managed-by") }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
{{- end }}
{{- range $key, $value := $customLabels }}
{{ $key }}: {{ $value }}
{{- end }}
{{- end -}}

{{/*
Labels to use on inmutable fields such as deploy.spec.selector.matchLabels or svc.spec.selector
{{ include "common.labels.matchLabels" (dict "customLabels" .Values.podLabels "context" $) -}}

We don't want to loop over custom labels appending them to the selector
since it's very likely that it will break deployemnts, services, etc.
However, it's important to overwrite the standard labels to if the user
overwrote them on metadata.labels fields.
*/}}
{{- define "common.labels.matchLabels" -}}
{{- $customLabels := default (dict) .customLabels -}}
app.kubernetes.io/name: {{ ternary (get $customLabels "app.kubernetes.io/name") (include "common.names.name" .context) (hasKey $customLabels "app.kubernetes.io/name") }}
app.kubernetes.io/instance: {{ ternary (get $customLabels "app.kubernetes.io/instance") .context.Release.Name (hasKey $customLabels "app.kubernetes.io/instance") }}
{{- end -}}
