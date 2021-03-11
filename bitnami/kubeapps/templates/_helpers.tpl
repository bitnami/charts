{{/* vim: set filetype=mustache: */}}

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
helm.sh/chart: {{ include "kubeapps.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "common.names.name" . }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "kubeapps.labels" -}}
app: {{ include "common.names.name" . }}
{{ template "kubeapps.extraAppLabels" . }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kubeapps.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.frontend.image .Values.dashboard.image .Values.apprepository.image .Values.apprepository.syncImage .Values.assetsvc.image .Values.kubeops.image .Values.authProxy.image .Values.pinnipedProxy.image .Values.hooks.image .Values.testImage) "global" .Values.global) }}
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
{{ include "common.names.fullname" . }}-internal-apprepository-controller
{{- end -}}

{{/*
Create name for the apprepository pre-upgrade job
*/}}
{{- define "kubeapps.apprepository-job-postupgrade.fullname" -}}
{{ include "common.names.fullname" . }}-internal-apprepository-job-postupgrade
{{- end -}}

{{/*
Create name for the apprepository cleanup job
*/}}
{{- define "kubeapps.apprepository-jobs-cleanup.fullname" -}}
{{ include "common.names.fullname" . }}-internal-apprepository-jobs-cleanup
{{- end -}}

{{/*
Create name for the db-secret secret bootstrap job
*/}}
{{- define "kubeapps.db-secret-jobs-cleanup.fullname" -}}
{{ include "common.names.fullname" . }}-internal-db-secret-jobs-cleanup
{{- end -}}

{{/*
Create name for the kubeapps upgrade job
*/}}
{{- define "kubeapps.kubeapps-jobs-upgrade.fullname" -}}
{{ include "common.names.fullname" . }}-internal-kubeapps-jobs-upgrade
{{- end -}}

{{/*
Create name for the assetsvc based on the fullname
*/}}
{{- define "kubeapps.assetsvc.fullname" -}}
{{ include "common.names.fullname" . }}-internal-assetsvc
{{- end -}}

{{/*
Create name for the dashboard based on the fullname
*/}}
{{- define "kubeapps.dashboard.fullname" -}}
{{ include "common.names.fullname" . }}-internal-dashboard
{{- end -}}

{{/*
Create name for the dashboard config based on the fullname
*/}}
{{- define "kubeapps.dashboard-config.fullname" -}}
{{ include "common.names.fullname" . }}-internal-dashboard-config
{{- end -}}

{{/*
Create name for the frontend config based on the fullname
*/}}
{{- define "kubeapps.frontend-config.fullname" -}}
{{ include "common.names.fullname" . }}-frontend-config
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
{{ include "common.names.fullname" . }}-internal-kubeops
{{- end -}}

{{/*
Create name for the kubeops config based on the fullname
*/}}
{{- define "kubeapps.kubeops-config.fullname" -}}
{{ include "common.names.fullname" . }}-kubeops-config
{{- end -}}

{{/*
Create name for the secrets related to an app repository
*/}}
{{- define "kubeapps.apprepository-secret.name" -}}
apprepo-{{ .name }}-secrets
{{- end -}}

{{/*
Create name for the secrets related to oauth2_proxy
*/}}
{{- define "kubeapps.oauth2_proxy-secret.name" -}}
{{ template "kubeapps.fullname" . }}-oauth2
{{- end -}}

{{/*
Create name for pinniped-proxy based on the fullname.
Currently used for a service name only.
*/}}
{{- define "kubeapps.pinniped-proxy.fullname" -}}
{{ include "common.names.fullname" . }}-internal-pinniped-proxy
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
