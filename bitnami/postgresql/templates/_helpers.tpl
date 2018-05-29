{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "postgresql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.master.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if .Values.replication.enabled -}}
{{- printf "%s-%s-%s" .Release.Name $name "master" | trunc 61 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "postgresql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper PostgreSQL image name
*/}}
{{- define "postgresql.image" -}}
{{- $registryName :=  default "docker.io" .Values.image.registry -}}
{{- $tag := default "latest" .Values.image.tag -}}
{{- printf "%s/%s:%s" $registryName .Values.image.repository $tag -}}
{{- end -}}

{{/*
Return the proper PostgreSQL metrics image name
*/}}
{{- define "metrics.image" -}}
{{- $registryName :=  default "docker.io" .Values.metrics.image.registry -}}
{{- $tag := default "latest" .Values.metrics.image.tag -}}
{{- printf "%s/%s:%s" $registryName .Values.metrics.image.repository $tag -}}
{{- end -}}