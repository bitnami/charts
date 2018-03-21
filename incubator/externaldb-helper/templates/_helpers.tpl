{{/* vim: set filetype=mustache: */}}
{{/*
CUSTOM TEMPLATES FOR SECRET MAPPING
    - host
    - port
    - username
    - password
*/}}

{{- define "externaldb.host" -}}
  {{- if eq .type "osba"}}
    {{- printf "%s" "host" -}}
  {{- else if eq .type "gce"}}
    {{- printf "%s" "host" -}}
  {{- else if eq .type "aws"}}
    {{- printf "%s" "host" -}}
  {{- else }}
    {{- printf "%s" "host" -}}
  {{- end }}
{{- end -}}

{{- define "externaldb.port" -}}
  {{- if eq .type "osba"}}
    {{- printf "%s" "port" -}}
  {{- else if eq .type "gce"}}
    {{- printf "%s" "port" -}}
  {{- else if eq .type "aws"}}
    {{- printf "%s" "port" -}}
  {{- else }}
    {{- printf "%s" "port" -}}
  {{- end }}
{{- end -}}

{{- define "externaldb.username" -}}
  {{- if eq .type "osba"}}
    {{- printf "%s" "username" -}}
  {{- else if eq .type "gce"}}
    {{- printf "%s" "username" -}}
  {{- else if eq .type "aws"}}
    {{- printf "%s" "username" -}}
  {{- else }}
    {{- printf "%s" "username" -}}
  {{- end }}
{{- end -}}

{{- define "externaldb.password" -}}
  {{- if eq .type "osba"}}
    {{- printf "%s" "password" -}}
  {{- else if eq .type "gce"}}
    {{- printf "%s" "password" -}}
  {{- else if eq .type "aws"}}
    {{- printf "%s" "password" -}}
  {{- else }}
    {{- printf "%s" "password" -}}
  {{- end }}
{{- end -}}
