{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ghost.name" -}}
{{- include "common.names.name" . -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ghost.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ghost.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ghost.chart" -}}
{{- include "common.names.chart" . -}}
{{- end -}}

{{/*
Return the proper Ghost image name
*/}}
{{- define "ghost.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name to change the volume permissions
*/}}
{{- define "ghost.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "ghost.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "ghost.storageClass" -}}
{{ include "common.storage.class" ( dict "persistence" .Values.persistence "global" .Values.global) }}
{{- end -}}

{{/*
Get the user defined LoadBalancerIP for this release.
Note, returns 127.0.0.1 if using ClusterIP.
*/}}
{{- define "ghost.serviceIP" -}}
{{- if eq .Values.service.type "ClusterIP" -}}
127.0.0.1
{{- else -}}
{{- .Values.service.loadBalancerIP | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
If not using ClusterIP, or if a host or LoadBalancerIP is not defined, the value will be empty.
*/}}
{{- define "ghost.host" -}}
{{- default (include "ghost.serviceIP" .) .Values.ghostHost -}}
{{- end -}}

{{/*
Gets the endpoint to be used for this application.
If not using ClusterIP, or if a host or LoadBalancerIP is not defined, the value will be empty.
*/}}
{{- define "ghost.endpoint" -}}
{{- $host := include "ghost.host" . -}}
{{- $path := trimSuffix "/" (trimPrefix "/" .Values.ghostPath) -}}

{{- printf "%s/%s" $host $path -}}
{{- end -}}

{{/*
Get external db secret name.
*/}}
{{- define "ghost.externalDb.secret.name" -}}
{{ include "ghost.fullname" . }}-external-db
{{- end -}}
