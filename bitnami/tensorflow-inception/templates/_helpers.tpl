{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper tensorflow-inception server image name
*/}}
{{- define "tensorflow-inception.server.image" -}}
{{- $registryName := .Values.server.image.registry -}}
{{- if .Values.global.registry -}}
    {{- $registryName := .Values.global.registry -}}
{{- else -}}
    {{- $registryName := .Values.server.image.registry -}}
{{- end -}}
{{- $repositoryName := .Values.server.image.repository -}}
{{- $tag := .Values.server.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the proper tensorflow-inception client image name
*/}}
{{- define "tensorflow-inception.client.image" -}}
{{- $registryName := .Values.client.image.registry -}}
{{- if .Values.global.registry -}}
    {{- $registryName := .Values.global.registry -}}
{{- else -}}
    {{- $registryName := .Values.client.image.registry -}}
{{- end -}}
{{- $repositoryName := .Values.client.image.repository -}}
{{- $tag := .Values.client.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
