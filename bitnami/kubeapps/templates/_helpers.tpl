{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kubeapps.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubeapps.fullname" -}}
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
{{- define "kubeapps.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels for additional kubeapps applications. Used on resources whose app name is different
from kubeapps
*/}}
{{- define "kubeapps.extraAppLabels" -}}
chart: {{ include "kubeapps.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
helm.sh/chart: {{ template "kubeapps.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "kubeapps.name" . }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "kubeapps.labels" -}}
app: {{ include "kubeapps.name" . }}
{{ template "kubeapps.extraAppLabels" . }}
{{- end -}}

{{/*
Render image reference
*/}}
{{- define "kubeapps.image" -}}
{{- $image := index . 0 -}}
{{- $global := index . 1 -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if $global -}}
    {{- if $global.imageRegistry -}}
        {{ $global.imageRegistry }}/{{ $image.repository }}:{{ $image.tag }}
    {{- else -}}
        {{ $image.registry }}/{{ $image.repository }}:{{ $image.tag }}
    {{- end -}}
{{- else -}}
    {{ $image.registry }}/{{ $image.repository }}:{{ $image.tag }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for PostgreSQL dependency.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kubeapps.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for the apprepository-controller based on the fullname
*/}}
{{- define "kubeapps.apprepository.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-apprepository-controller
{{- end -}}

{{/*
Create name for the apprepository pre-upgrade job
*/}}
{{- define "kubeapps.apprepository-job-postupgrade.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-apprepository-job-postupgrade
{{- end -}}

{{/*
Create name for the apprepository cleanup job
*/}}
{{- define "kubeapps.apprepository-jobs-cleanup.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-apprepository-jobs-cleanup
{{- end -}}

{{/*
Create name for the db-secret secret bootstrap job
*/}}
{{- define "kubeapps.db-secret-jobs-cleanup.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-db-secret-jobs-cleanup
{{- end -}}

{{/*
Create name for the kubeapps upgrade job
*/}}
{{- define "kubeapps.kubeapps-jobs-upgrade.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-kubeapps-jobs-upgrade
{{- end -}}

{{/*
Create name for the assetsvc based on the fullname
*/}}
{{- define "kubeapps.assetsvc.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-assetsvc
{{- end -}}

{{/*
Create name for the dashboard based on the fullname
*/}}
{{- define "kubeapps.dashboard.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-dashboard
{{- end -}}

{{/*
Create name for the dashboard config based on the fullname
*/}}
{{- define "kubeapps.dashboard-config.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-dashboard-config
{{- end -}}

{{/*
Create name for the frontend config based on the fullname
*/}}
{{- define "kubeapps.frontend-config.fullname" -}}
{{ template "kubeapps.fullname" . }}-frontend-config
{{- end -}}

{{/*
Create proxy_pass for the frontend config
*/}}
{{- define "kubeapps.frontend-config.proxy_pass" -}}
http://{{ template "kubeapps.kubeops.fullname" . }}:{{ .Values.kubeops.service.port }}
{{- end -}}

{{/*
Create name for kubeops based on the fullname
*/}}
{{- define "kubeapps.kubeops.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-kubeops
{{- end -}}

{{/*
Create name for the kubeops config based on the fullname
*/}}
{{- define "kubeapps.kubeops-config.fullname" -}}
{{ template "kubeapps.fullname" . }}-kubeops-config
{{- end -}}

{{/*
Create name for the secrets related to an app repository
*/}}
{{- define "kubeapps.apprepository-secret.name" -}}
apprepo-{{ .name }}-secrets
{{- end -}}

{{/*
Repositories that include a caCert or an authorizationHeader
*/}}
{{- define "kubeapps.repos-with-orphan-secrets" -}}
{{- range .Values.apprepository.initialRepos }}
{{- if or .caCert .authorizationHeader }}
.name
{{- end }}
{{- end }}
{{- end -}}

{{/*
Frontend service port number
*/}}
{{- define "kubeapps.frontend-port-number" -}}
{{- if .Values.authProxy.enabled -}}
3000
{{- else -}}
8080
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kubeapps.imagePullSecrets" -}}
{{/*
We can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "kubeapps.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "kubeapps.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Returns the kubeappsCluster based on the configured clusters by finding the cluster without
a defined apiServiceURL.
*/}}
{{- define "kubeapps.kubeappsCluster" -}}
    {{- $kubeappsCluster := "" }}
    {{- if eq (len .Values.clusters) 0 }}
        {{- fail "At least one cluster must be defined." }}
    {{- end }}
    {{- range .Values.clusters }}
        {{- if eq (.apiServiceURL | toString) "<nil>" }}
            {{- if eq $kubeappsCluster "" }}
                {{- $kubeappsCluster = .name }}
            {{- else }}
                {{- fail "Only one cluster can be specified without an apiServiceURL to refer to the cluster on which Kubeapps is installed." }}
            {{- end }}
        {{- end }}
    {{- end }}
    {{- $kubeappsCluster }}
{{- end -}}

{{/*
Returns a JSON list of cluster names only (without sensitive tokens etc.)
*/}}
{{- define "kubeapps.clusterNames" -}}
    {{- $sanitizedClusters := list }}
    {{- range .Values.clusters }}
    {{- $sanitizedClusters = append $sanitizedClusters .name }}
    {{- end }}
    {{- $sanitizedClusters | toJson }}
{{- end -}}
