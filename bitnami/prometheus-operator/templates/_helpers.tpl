{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "prometheus-operator.name" -}}
{{- include "common.names.name" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prometheus-operator.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end }}

{{/* Name suffixed with operator */}}
{{- define "prometheus-operator.operator.name" -}}
{{- printf "%s-operator" (include "prometheus-operator.name" .) -}}
{{- end }}

{{/* Name suffixed with prometheus */}}
{{- define "prometheus-operator.prometheus.name" -}}
{{- printf "%s-prometheus" (include "prometheus-operator.name" .) -}}
{{- end }}

{{/* Name suffixed with alertmanager */}}
{{- define "prometheus-operator.alertmanager.name" -}}
{{- printf "%s-alertmanager" (include "prometheus-operator.name" .) -}}
{{- end }}

{{/* Fullname suffixed with operator */}}
{{- define "prometheus-operator.operator.fullname" -}}
{{- printf "%s-operator" (include "prometheus-operator.fullname" .) -}}
{{- end }}

{{/* Fullname suffixed with prometheus */}}
{{- define "prometheus-operator.prometheus.fullname" -}}
{{- printf "%s-prometheus" (include "prometheus-operator.fullname" .) -}}
{{- end }}

{{/* Fullname suffixed with alertmanager */}}
{{- define "prometheus-operator.alertmanager.fullname" -}}
{{- printf "%s-alertmanager" (include "prometheus-operator.fullname" .) -}}
{{- end }}

{{- define "prometheus-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Labels for operator
*/}}
{{- define "prometheus-operator.operator.labels" -}}
{{ include "common.labels.standard" . }}
app.kubernetes.io/component: operator
{{- end -}}

{{/*
Labels for prometheus
*/}}
{{- define "prometheus-operator.prometheus.labels" -}}
{{ include "common.labels.standard" . }}
app.kubernetes.io/component: prometheus
{{- end -}}

{{/*
Labels for alertmanager
*/}}
{{- define "prometheus-operator.alertmanager.labels" -}}
{{ include "common.labels.standard" . }}
app.kubernetes.io/component: alertmanager
{{- end -}}

{{/*
matchLabels for operator
*/}}
{{- define "prometheus-operator.operator.matchLabels" -}}
{{ include "common.labels.matchLabels" . }}
app.kubernetes.io/component: operator
{{- end -}}

{{/*
matchLabels for prometheus
*/}}
{{- define "prometheus-operator.prometheus.matchLabels" -}}
{{ include "common.labels.matchLabels" . }}
app.kubernetes.io/component: prometheus
{{- end -}}

{{/*
matchLabels for alertmanager
*/}}
{{- define "prometheus-operator.alertmanager.matchLabels" -}}
{{ include "common.labels.matchLabels" . }}
app.kubernetes.io/component: alertmanager
{{- end -}}

{{/*
Return the proper Prometheus Operator image name
*/}}
{{- define "prometheus-operator.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.operator.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Prometheus Operator Reloader image name
*/}}
{{- define "prometheus-operator.prometheusConfigReloader.image" -}}
{{- if and .Values.operator.prometheusConfigReloader.image.registry (and .Values.operator.prometheusConfigReloader.image.repository .Values.operator.prometheusConfigReloader.image.tag) }}
{{- include "common.images.image" (dict "imageRoot" .Values.operator.prometheusConfigReloader.image "global" .Values.global) }}
{{- else -}}
{{- include "prometheus-operator.image" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper ConfigMap Reload image name
*/}}
{{- define "prometheus-operator.configmapReload.image" -}}
{{- if and .Values.operator.configmapReload.image.registry (and .Values.operator.configmapReload.image.repository .Values.operator.configmapReload.image.tag) }}
{{- include "common.images.image" (dict "imageRoot" .Values.operator.configmapReload.image "global" .Values.global) }}
{{- else -}}
{{- include "prometheus-operator.image" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Prometheus Image name
*/}}
{{- define "prometheus-operator.prometheus.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.prometheus.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Thanos Image name
*/}}
{{- define "prometheus-operator.prometheus.thanosImage" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.prometheus.thanos.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Alertmanager Image name
*/}}
{{- define "prometheus-operator.alertmanager.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.alertmanager.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "prometheus-operator.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.operator.image .Values.operator.prometheusConfigReloader.image .Values.operator.configmapReload.image .Values.prometheus.image .Values.prometheus.thanos.image .Values.alertmanager.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the operator service account to use
*/}}
{{- define "prometheus-operator.operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create -}}
    {{ default (include "prometheus-operator.operator.fullname" .) .Values.operator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.operator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the prometheus service account to use
*/}}
{{- define "prometheus-operator.prometheus.serviceAccountName" -}}
{{- if .Values.prometheus.serviceAccount.create -}}
    {{ default (include "prometheus-operator.prometheus.fullname" .) .Values.prometheus.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.prometheus.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the alertmanager service account to use
*/}}
{{- define "prometheus-operator.alertmanager.serviceAccountName" -}}
{{- if .Values.alertmanager.serviceAccount.create -}}
    {{ default (include "prometheus-operator.alertmanager.fullname" .) .Values.alertmanager.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.alertmanager.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for PodSecurityPolicy.
*/}}
{{- define "podSecurityPolicy.apiVersion" -}}
{{- if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "policy/v1beta1" -}}
{{- else -}}
{{- print "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "prometheus-operator.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
