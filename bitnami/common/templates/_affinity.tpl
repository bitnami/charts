{{/* vim: set filetype=mustache: */}}

{{/*
Return a soft nodeAffinity definition 
{{ include "common.affinity.node.soft" (dict "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "common.affinity.node.soft" -}}
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
{{ include "common.affinity.node.soft" (dict "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "common.affinity.node.hard" -}}
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
Return a soft podAffinity/podAntiAffinity definition 
{{ include "common.affinity.pod.soft" (dict "component" "FOO" "context" $) -}}
*/}}
{{- define "common.affinity.pod.soft" -}}
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
{{ include "common.affinity.pod.hard" (dict "component" "FOO" "context" $) -}}
*/}}
{{- define "common.affinity.pod.hard" -}}
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
