{{/* vim: set filetype=mustache: */}}

{{/*
Return a soft nodeAffinity definition 
{{ include "common.affinities.node.soft" (dict "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "common.affinities.node.soft" -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - preference:
      matchExpressions:
        key: {{ .key }}
        operator: In
        values:
          {{- range .values }}
          - {{ . }}
          {{- end }}
    weight: 1
{{- end -}}

{{/*
Return a hard nodeAffinity definition
{{ include "common.affinities.node.soft" (dict "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "common.affinities.node.hard" -}}
requiredDuringSchedulingIgnoredDuringExecution:
  nodeSelectorTerms:
    - matchExpressions:
        key: {{ .key }}
        operator: In
        values:
          {{- range .values }}
          - {{ . }}
          {{- end }}
{{- end -}}

{{/*
Return a nodeAffinity definition
{{ include "common.affinities.node" (dict "type" "soft" "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "common.affinities.node" -}}
  {{- if eq .type "soft" }}
    {{- include "common.affinities.node.soft" . -}}
  {{- else if eq .type "hard" }}
    {{- include "common.affinities.node.hard" . -}}
  {{- end -}}
{{- end -}}

{{/*
Return a soft podAffinity/podAntiAffinity definition
{{ include "common.affinities.pod.soft" (dict "component" "FOO" "context" $) -}}
*/}}
{{- define "common.affinities.pod.soft" -}}
{{- $component := default "" .component -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - podAffinityTerm:
      labelSelector:
        matchLabels: {{- (include "common.labels.matchLabels" .context) | nindent 10 }}
          {{- if not (empty $component) }}
          {{ printf "app.kubernetes.io/component: %s" $component }}
          {{- end }}
      namespaces:
        - {{ .context.Release.Namespace }}
      topologyKey: kubernetes.io/hostname
    weight: 1
{{- end -}}

{{/*
Return a hard podAffinity/podAntiAffinity definition
{{ include "common.affinities.pod.hard" (dict "component" "FOO" "context" $) -}}
*/}}
{{- define "common.affinities.pod.hard" -}}
{{- $component := default "" .component -}}
requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchLabels: {{- (include "common.labels.matchLabels" .context) | nindent 8 }}
        {{- if not (empty $component) }}
        {{ printf "app.kubernetes.io/component: %s" $component }}
        {{- end }}
    namespaces:
      - {{ .context.Release.Namespace }}
    topologyKey: kubernetes.io/hostname
{{- end -}}

{{/*
Return a podAffinity/podAntiAffinity definition
{{ include "common.affinities.pod" (dict "type" "soft" "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "common.affinities.pod" -}}
  {{- if eq .type "soft" }}
    {{- include "common.affinities.pod.soft" . -}}
  {{- else if eq .type "hard" }}
    {{- include "common.affinities.pod.hard" . -}}
  {{- end -}}
{{- end -}}
