{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fluentd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fluentd.fullname" -}}
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
{{- define "fluentd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "fluentd.labels" -}}
app.kubernetes.io/name: {{ include "fluentd.name" . }}
helm.sh/chart: {{ include "fluentd.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on daemonset.spec.selector.matchLabels, statefulset.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "fluentd.matchLabels" -}}
app.kubernetes.io/name: {{ include "fluentd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return the proper Fluentd image name
*/}}
{{- define "fluentd.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global.imageRegistry }}
    {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "fluentd.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "fluentd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "fluentd.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "fluentd.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image.repository) (not (.Values.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image.repository }}:{{ .Values.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- end -}}

{{/*
Validate data
*/}}
{{- define "fluentd.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "fluentd.validateValues.deployment" .) -}}
{{- $messages := append $messages (include "fluentd.validateValues.rbac" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
 {{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Fluentd - forwarders and aggregators can't be disabled at the same time */}}
{{- define "fluentd.validateValues.deployment" -}}
{{- if and (not .Values.forwarder.enabled) (not .Values.aggregator.enabled) -}}
fluentd:
    You have disabled both the forwarders and the aggregators.
    Please enable at least one of them (--set forwarder.enabled=true) (--set aggregator.enabled=true)
{{- end -}}
{{- end -}}

{{/* Validate values of Fluentd - must create serviceAccount to create enable RBAC */}}
{{- define "fluentd.validateValues.rbac" -}}
{{- if and .Values.rbac.create (not .Values.serviceAccount.create) -}}
fluentd: rbac.create
    A ServiceAccount is required ("rbac.create=true" is set)
    Please create a ServiceAccount (--set serviceAccount.create=true)
{{- end -}}
{{- end -}}

{{/*
Get the forwarder configmap name.
*/}}
{{- define "fluentd.forwarder.configMap" -}}
{{- if .Values.forwarder.configMap -}}
    {{- printf "%s" (tpl .Values.forwarder.configMap $) -}}
{{- else -}}
    {{- printf "%s-forwarder-cm" (include "fluentd.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the aggregator configmap name.
*/}}
{{- define "fluentd.aggregator.configMap" -}}
{{- if .Values.aggregator.configMap -}}
    {{- printf "%s" (tpl .Values.aggregator.configMap $) -}}
{{- else -}}
    {{- printf "%s-aggregator-cm" (include "fluentd.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the certificates secret name.
*/}}
{{- define "fluentd.tls.secretName" -}}
{{- if .Values.tls.existingSecret -}}
    {{- printf "%s" (tpl .Values.tls.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-tls" (include "fluentd.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "fluentd.tplValue" (dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "fluentd.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
