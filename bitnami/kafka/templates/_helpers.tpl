{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kafka.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kafka.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kafka.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Kafka image name
*/}}
{{- define "kafka.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $tag := .Values.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName .Values.image.repository $tag -}}
{{- end -}}

{{/*
Return the proper Kafka exporter image name
*/}}
{{- define "kafka.metrics.kafka.image" -}}
{{- $registryName := .Values.metrics.kafka.image.registry -}}
{{- $tag := .Values.metrics.kafka.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName .Values.metrics.kafka.image.repository $tag -}}
{{- end -}}

{{/*
Return the proper JMX exporter image name
*/}}
{{- define "kafka.metrics.jmx.image" -}}
{{- $registryName := .Values.metrics.jmx.image.registry -}}
{{- $tag := .Values.metrics.jmx.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName .Values.metrics.jmx.image.repository $tag -}}
{{- end -}}
{{/*

Create a default fully qualified zookeeper name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kafka.zookeeper.fullname" -}}
{{- $name := default "zookeeper" .Values.zookeeper.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}