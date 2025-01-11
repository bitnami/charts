{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Kubernetes standard labels
{{- include "common.labels.standard" $ }}
{{- include "common.labels.standard" (dict "customLabels" .Values.commonLabels "context" $) }}
{{- include "common.labels.standard" (dict "customLabels" .Values.commonLabels "context" $ "component" "FOO") }}
*/}}
{{- define "common.labels.standard" -}}
{{- $context := default . .context -}}
{{- $default := dict
  "app.kubernetes.io/instance" $context.Release.Name
  "app.kubernetes.io/managed-by" $context.Release.Service
  "app.kubernetes.io/name" (include "common.names.name" $context)
  "helm.sh/chart" (include "common.names.chart" $context)
-}}
{{- with $context.Chart.AppVersion -}}
  {{- $_ := set $default "app.kubernetes.io/version" . -}}
{{- end -}}
{{- $component := dict -}}
{{- with .component -}}
  {{- $_ := set $component "app.kubernetes.io/component" . -}}
{{- end -}}
{{- /* If "component" key is present it will overwrite label from .customLabels for compatibility with selector */ -}}
{{- include "common.tplvalues.merge" (dict "values" (compact (list $component .customLabels $default)) "context" $context) }}
{{- end -}}

{{/*
Labels used on immutable fields such as deploy.spec.selector.matchLabels or svc.spec.selector
{{- include "common.labels.matchLabels" $ }}
{{- include "common.labels.matchLabels" (dict "customLabels" .Values.podLabels "context" $) }}
{{- include "common.labels.matchLabels" (dict "customLabels" .Values.podLabels "context" $ "component" "FOO") }}

We don't want to loop over custom labels appending them to the selector
since it's very likely that it will break deployments, services, etc.
However, it's important to overwrite the standard labels if the user
overwrote them on metadata.labels fields.
*/}}
{{- define "common.labels.matchLabels" -}}
{{- $context := default . .context -}}
{{- $default := dict
  "app.kubernetes.io/instance" $context.Release.Name
  "app.kubernetes.io/name" (include "common.names.name" $context)
-}}
{{- with .component -}}
  {{- $_ := set $default "app.kubernetes.io/component" . -}}
{{- end -}}
{{- if .customLabels -}}
{{- merge
  (pick
    (include "common.tplvalues.render" (dict "value" .customLabels "context" $context) | fromYaml)
    "app.kubernetes.io/name"
    "app.kubernetes.io/instance"
  )
  $default | toYaml
-}}
{{- else -}}
  {{- $default | toYaml }}
{{- end -}}
{{- end -}}
