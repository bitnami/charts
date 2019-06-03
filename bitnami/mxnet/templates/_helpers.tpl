{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mxnet.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mxnet.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mxnet.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper MXNet image name
*/}}
{{- define "mxnet.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/* Validate values of MXNet - number of workers must be greater than 0 */}}
{{- define "mxnet.entrypoint" -}}
{{- if .Values.entrypoint.file }}
  {{- if (.Values.entrypoint.file | regexFind "[.]py$") }}
python3 {{ .Values.entrypoint.file }} {{ if .Values.entrypoint.args }}{{ .Values.entrypoint.args }}{{ end }}
  {{- else }}
bash {{ .Values.entrypoint.file }} {{ if .Values.entrypoint.args }}{{ .Values.entrypoint.args }}{{ end }}
  {{- end }}
  {{- else }}
sleep infinity
  {{- end }}
{{- end -}}

{{/*
Return the proper git image name
*/}}
{{- define "git.image" -}}
{{- $registryName := .Values.git.registry -}}
{{- $repositoryName := .Values.git.repository -}}
{{- $tag := .Values.git.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mxnet.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if or .Values.image.pullSecrets .Values.git.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.git.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if or .Values.image.pullSecrets .Values.git.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.git.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "mxnet.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "mxnet.validateValues.mode" .) -}}
{{- $messages := append $messages (include "mxnet.validateValues.workerCount" .) -}}
{{- $messages := append $messages (include "mxnet.validateValues.serverCount" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of MXNet - must provide a valid mode ("distributed" or "standalone") */}}
{{- define "mxnet.validateValues.mode" -}}
{{- if and (ne .Values.mode "distributed") (ne .Values.mode "standalone") -}}
mxnet: mode
    Invalid mode selected. Valid values are "distributed" and
    "standalone". Please set a valid mode (--set mode="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of MXNet - number of workers must be greater than 0 */}}
{{- define "mxnet.validateValues.workerCount" -}}
{{- $replicaCount := int .Values.workerCount }}
{{- if and (eq .Values.mode "distributed") (lt $replicaCount 1) -}}
mxnet: workerCount
    Worker count must be greater than 0 in distributed mode!!
    Please set a valid worker count size (--set workerCount=X)
{{- end -}}
{{- end -}}

{{- define "mxnet.parseEnvVars" -}}
{{- range $env := . }}
{{- if $env.value }}
- name: {{ $env.name }}
  value: {{ $env.value | quote }}
{{- else if $env.valueFrom }}
- name: {{ $env.name }}
  valueFrom:
{{ toYaml $env.valueFrom | indent 4 }}
{{- else }} {{/* Leave this for future compatibility */}}
-
{{ toYaml $env | indent 2}}
{{- end }}
{{- end }}
{{- end }}

{{/* Validate values of MXNet - number of workers must be greater than 0 */}}
{{- define "mxnet.validateValues.serverCount" -}}
{{- $replicaCount := int .Values.serverCount }}
{{- if and (eq .Values.mode "distributed") (lt $replicaCount 1) -}}
mxnet: serverCount
    Server count must be greater than 0 in distributed mode!!
    Please set a valid worker count size (--set serverCount=X)
{{- end -}}
{{- end -}}
