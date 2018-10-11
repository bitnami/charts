{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "postgresql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgresql.master.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if .Values.replication.enabled -}}
{{- printf "%s-%s-%s" .Release.Name $name "master" | trunc 63 | trimSuffix "-" -}}
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
{{- $registryName := .Values.image.registry -}}
{{- if .Values.global.registry -}}
    {{- $registryName := .Values.global.registry -}}
{{- else -}}
    {{- $registryName := .Values.image.registry -}}
{{- end -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the proper PostgreSQL metrics image name
*/}}
{{- define "metrics.image" -}}
{{- $registryName :=  default "docker.io" .Values.metrics.image.registry -}}
{{- $tag := default "latest" .Values.metrics.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName .Values.metrics.image.repository $tag -}}
{{- end -}}
