{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}
{{/*
Kubernetes standard labels
*/}}
{{- define "common.labels.standard" -}}
{{- if and (hasKey . "customLabels") (hasKey . "context") -}}
{{ merge
        (include "common.tplvalues.render" (dict "value" .customLabels "context" .context) | fromYaml)
        (dict
            "app.kubernetes.io/name" (include "common.names.name" .context)
            "helm.sh/chart" (include "common.names.chart" .context)
            "app.kubernetes.io/instance" .context.Release.Name
            "app.kubernetes.io/managed-by" .context.Release.Service
        )
    | toYaml
}}
{{- else -}}
app.kubernetes.io/name: {{ include "common.names.name" . }}
helm.sh/chart: {{ include "common.names.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{- end }}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "common.labels.matchLabels" -}}
{{- if and (hasKey . "customLabels") (hasKey . "context") -}}
{{ merge
        (include "common.tplvalues.render" (dict "value" .customLabels "context" .context) | fromYaml)
        (dict
            "app.kubernetes.io/name" (include "common.names.name" .context)
            "app.kubernetes.io/instance" .context.Release.Name
        )
    | toYaml
}}
{{- else -}}
app.kubernetes.io/name: {{ include "common.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- end -}}
