{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "apache.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "apache.fullname" -}}
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
Common labels
*/}}
{{- define "apache.labels" -}}
app.kubernetes.io/name: {{ include "apache.name" . }}
helm.sh/chart: {{ include "apache.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "apache.matchLabels" -}}
app.kubernetes.io/name: {{ include "apache.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return the proper Apache image name
*/}}
{{- define "apache.image" -}}
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

{{/*
Return the proper Apache Docker Image Registry Secret Names
*/}}
{{- define "apache.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if or .Values.image.pullSecrets .Values.metrics.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.metrics.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if or .Values.image.pullSecrets .Values.metrics.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- range .Values.metrics.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "apache.metrics.image" -}}
{{- $registryName := .Values.metrics.image.registry -}}
{{- $repositoryName := .Values.metrics.image.repository -}}
{{- $tag := .Values.metrics.image.tag | toString -}}
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
Return true if mouting a static web page
*/}}
{{- define "apache.useHtdocs" -}}
{{ default "" (or .Values.cloneHtdocsFromGit.enabled .Values.htdocsConfigMap .Values.htdocsPVC) }}
{{- end -}}

{{/*
Return associated volume
*/}}
{{- define "apache.htdocsVolume" -}}
{{- if .Values.cloneHtdocsFromGit.enabled }}
emptyDir: {}
{{- else if .Values.htdocsConfigMap }}
configMap:
  name: {{ .Values.htdocsConfigMap }}
{{- else if .Values.htdocsPVC }}
persistentVolumeClaim:
  claimName: {{ .Values.htdocsPVC }}
{{- end }}
{{- end -}}

{{/*
Validate data
*/}}
{{- define "apache.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "apache.validateValues.htdocs" .) -}}
{{- $messages := append $messages (include "apache.validateValues.htdocsGit" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
 {{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "apache.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Validate data (htdocs)
*/}}
{{- define "apache.validateValues.htdocs" -}}
{{- if or (and .Values.cloneHtdocsFromGit.enabled (or .Values.htdocsPVC .htdocsConfigMap )) (and .Values.htdocsPVC (or .Values.htdocsConfigMap .Values.cloneHtdocsFromGit.enabled )) (and .Values.htdocsConfigMap (or .Values.htdocsPVC .Values.cloneHtdocsFromGit.enabled )) }}
apache: htdocs
    You have selected more than one way of deploying htdocs. Please select only one of htdocsConfigMap cloneHtdocsFromGit or htdocsVolume
{{- end }}
{{- end -}}

{{/*
Validate data (htdocs git)
*/}}
{{- define "apache.validateValues.htdocsGit" -}}
{{- if .Values.cloneHtdocsFromGit.enabled }}
  {{- if not .Values.cloneHtdocsFromGit.repository }}
apache: htdocs-git-repository
    You did not specify a git repository to clone. Please set cloneHtdocsFromGit.repository
  {{- end }}
  {{- if not .Values.cloneHtdocsFromGit.branch }}
apache: htdocs-git-branch
    You did not specify a branch to checkout in the git repository. Please set cloneHtdocsFromGit.branch
  {{- end }}
{{- end -}}
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
Get the vhosts config map name.
*/}}
{{- define "apache.vhostsConfigMap" -}}
{{- if .Values.vhostsConfigMap -}}
    {{- printf "%s" (tpl .Values.vhostsConfigMap $) -}}
{{- else -}}
    {{- printf "%s-vhosts" (include "apache.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the httpd.conf config map name.
*/}}
{{- define "apache.httpdConfConfigMap" -}}
{{- if .Values.httpdConfConfigMap -}}
    {{- printf "%s" (tpl .Values.httpdConfConfigMap $) -}}
{{- else -}}
    {{- printf "%s-httpd-conf" (include "apache.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "apache.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "apache.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
