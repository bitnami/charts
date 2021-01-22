{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "solr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "solr.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Define the name of the client service for solr
*/}}
{{- define "solr.service-name" -}}
{{- printf "%s-%s" (include "solr.fullname" .) "svc" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the name of the solr exporter
*/}}
{{- define "solr.exporter-name" -}}
{{- printf "%s-%s" (include "solr.fullname" .) "exporter" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified zookeeper name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "solr.zookeeper.fullname" -}}
{{- if .Values.zookeeper.fullnameOverride -}}
{{- .Values.zookeeper.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "zookeeper" .Values.zookeeper.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
The name of the zookeeper headless service
*/}}
{{- define "solr.zookeeper-service-name" -}}
{{ printf "%s-%s" (include "solr.zookeeper.fullname" .) "headless" | trunc 63 | trimSuffix "-"  }}
{{- end -}}


{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "solr.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image ) "global" .Values.global) }}
{{- end -}}


{{/*
Return the proper Apache Solr image name
*/}}
{{- define "solr.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "solr.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "solr.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "solr.storageClass" -}}
{{- include "common.storage.class" (dict "persistence" .Values.persistence "global" .Values.global) -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "solr.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "solr.validateValues.externalAccessServiceType" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Solr - service type for external access */}}
{{- define "solr.validateValues.externalAccessServiceType" -}}
{{- if and (not (eq .Values.service.type "NodePort")) (not (eq .Values.service.type "LoadBalancer")) -}}
solr: service.type
    Available service type for external access are NodePort or LoadBalancer.
{{- end -}}
{{- end -}}