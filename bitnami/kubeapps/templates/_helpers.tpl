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
Create a default fully qualified app name for MongoDB dependency.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kubeapps.mongodb.fullname" -}}
{{- $name := default "mongodb" .Values.mongodb.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kubeapps.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create name for the apprepository-controller based on the fullname
*/}}
{{- define "kubeapps.apprepository.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-apprepository-controller
{{- end -}}

{{/*
Create name for the apprepository bootstrap job
*/}}
{{- define "kubeapps.apprepository-jobs-bootstrap.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-apprepository-jobs-bootstrap
{{- end -}}

{{/*
Create name for the apprepository cleanup job
*/}}
{{- define "kubeapps.apprepository-jobs-cleanup.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-apprepository-jobs-cleanup
{{- end -}}

{{/*
Create name for the mongodb secret bootstrap job
*/}}
{{- define "kubeapps.mongodb-jobs-cleanup.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-mongodb-jobs-cleanup
{{- end -}}

{{/*
Create name for the kubeapps upgrade job
*/}}
{{- define "kubeapps.kubeapps-jobs-upgrade.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-kubeapps-jobs-upgrade
{{- end -}}

{{/*
Create name for the chartsvc based on the fullname
*/}}
{{- define "kubeapps.chartsvc.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-chartsvc
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
Create name for the tiller-proxy based on the fullname
*/}}
{{- define "kubeapps.tiller-proxy.fullname" -}}
{{ template "kubeapps.fullname" . }}-internal-tiller-proxy
{{- end -}}
