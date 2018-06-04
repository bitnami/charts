{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "master.fullname" -}}
{{- printf "%s-%s" .Release.Name "mysql-master" | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "slave.fullname" -}}
{{- printf "%s-%s" .Release.Name "mysql-slave" | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "mysql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Return the proper MySQL image name
*/}}
{{- define "mysql.image" -}}
{{- $registryName :=  default "docker.io" .Values.image.registry -}}
{{- $tag := default "latest" .Values.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName .Values.image.repository $tag -}}
{{- end }}

{{/*
Return the proper MySQL metrics exporter image name
*/}}
{{- define "metrics.image" -}}
{{- $registryName :=  default "docker.io" .Values.metrics.image.registry -}}
{{- $tag := default "latest" .Values.metrics.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName .Values.metrics.image.repository $tag -}}
{{- end }}
