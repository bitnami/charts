{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{define "lamp.name"}}{{default "lamp" .Values.nameOverride | trunc 24 }}{{end}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{define "lamp.fullname"}}
{{- $name := default "lamp" .Values.nameOverride -}}
{{printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{end}}

{{define "lamp.args"}}
{{- $type := default "php" .Values.phpFramework -}}
{{- if eq "laravel" $type -}}
["php", "artisan", "serve", "--host=0.0.0.0", "--port=80"]
{{- else -}}
["php", "-S", "0.0.0.0:80"]
{{- end -}}
{{ end}}

{{define "lamp.envs"}}
{{- $type := default "php" .Values.phpFramework -}}
{{- if eq "laravel" $type -}}
        - name: APP_KEY
          value: base64:3XSuN7vqnaL+bL44wng95RXHzCWuXOesIxpjhORYl8A=
{{- end -}}
{{end}}
