{{/*
Create a default fully qualified kafka name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dp.kafka.fullname" -}}
{{- if .Values.kafka.fullnameOverride -}}
{{- .Values.kafka.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "kafka" .Values.kafka.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Kafka image name
*/}}
{{- define "dp.kafka.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.kafka.image "global" .Values.kafka.global) }}
{{- end -}}

{{/*
Create a default fully qualified spark name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dp.spark.fullname" -}}
{{- if .Values.spark.fullnameOverride -}}
{{- .Values.spark.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "spark" .Values.spark.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- /*
Return the Spark Service name. As we use a headless service we need to append -master-svc to
the service name.
*/ -}}
{{- define "dp.spark.master.service.name" -}}
{{ include "dp.spark.fullname" . }}-master-svc
{{- end -}}

{{/*
Create a default fully qualified solr name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dp.solr.fullname" -}}
{{- if .Values.solr.fullnameOverride -}}
{{- .Values.solr.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "solr" .Values.solr.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Solr credential secret name */}}
{{- define "dp.solr.secretName" -}}
{{- coalesce .Values.solr.existingSecret (include "dp.solr.fullname" .) -}}
{{- end -}}

{{/*
Define the name of the solr exporter
*/}}
{{- define "dp.solr.exporter-name" -}}
{{- printf "%s-%s" (include "dp.solr.fullname" .) "exporter" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
