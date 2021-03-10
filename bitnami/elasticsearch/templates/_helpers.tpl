{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper ES image name
*/}}
{{- define "elasticsearch.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Create a default fully qualified master name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.master.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.master.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified ingest name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.ingest.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.ingest.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified coordinating name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.coordinating.fullname" -}}
{{- if .Values.global.kibanaEnabled -}}
{{- printf "%s-%s" .Release.Name .Values.global.coordinating.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.global.coordinating.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the hostname of every ElasticSearch seed node
*/}}
{{- define "elasticsearch.hosts" -}}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $releaseNamespace := .Release.Namespace }}
{{- $masterFullname := include "elasticsearch.master.fullname" . }}
{{- $coordinatingFullname := include "elasticsearch.coordinating.fullname" . }}
{{- $dataFullname := include "elasticsearch.data.fullname" . }}
{{- $ingestFullname := include "elasticsearch.ingest.fullname" . }}
{{- $masterFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- $coordinatingFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- $dataFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- if .Values.ingest.enabled }}
{{- $ingestFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified data name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.data.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.data.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{ template "elasticsearch.initScriptsSecret" . }}
{{/*
Get the initialization scripts volume name.
*/}}
{{- define "elasticsearch.initScripts" -}}
{{- printf "%s-init-scripts" (include "common.names.fullname" .) -}}
{{- end -}}

{{ template "elasticsearch.initScriptsCM" . }}
{{/*
Get the initialization scripts ConfigMap name.
*/}}
{{- define "elasticsearch.initScriptsCM" -}}
{{- printf "%s" .Values.initScriptsCM -}}
{{- end -}}

{{ template "elasticsearch.initScriptsSecret" . }}
{{/*
Get the initialization scripts Secret name.
*/}}
{{- define "elasticsearch.initScriptsSecret" -}}
{{- printf "%s" .Values.initScriptsSecret -}}
{{- end -}}

{{/*
 Create the name of the master service account to use
 */}}
{{- define "elasticsearch.master.serviceAccountName" -}}
{{- if .Values.master.serviceAccount.create -}}
    {{ default (include "elasticsearch.master.fullname" .) .Values.master.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.master.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the coordinating-only service account to use
 */}}
{{- define "elasticsearch.coordinating.serviceAccountName" -}}
{{- if .Values.coordinating.serviceAccount.create -}}
    {{ default (include "elasticsearch.coordinating.fullname" .) .Values.coordinating.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.coordinating.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the data service account to use
 */}}
{{- define "elasticsearch.data.serviceAccountName" -}}
{{- if .Values.data.serviceAccount.create -}}
    {{ default (include "elasticsearch.data.fullname" .) .Values.data.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.data.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified metrics name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.metrics.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.metrics.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper ES exporter image name
*/}}
{{- define "elasticsearch.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper sysctl image name
*/}}
{{- define "elasticsearch.sysctl.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.sysctlImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "elasticsearch.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.curator.image .Values.sysctlImage .Values.volumePermissions.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "elasticsearch.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Storage Class
Usage:
{{ include "elasticsearch.storageClass" (dict "global" .Values.global "local" .Values.master) }}
*/}}
{{- define "elasticsearch.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .global -}}
    {{- if .global.storageClass -}}
        {{- if (eq "-" .global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .local.persistence.storageClass -}}
              {{- if (eq "-" .local.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .local.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .local.persistence.storageClass -}}
        {{- if (eq "-" .local.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .local.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for cronjob APIs.
*/}}
{{- define "cronjob.apiVersion" -}}
{{- if semverCompare "< 1.8-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "batch/v2alpha1" }}
{{- else if semverCompare ">=1.8-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "batch/v1beta1" }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for podsecuritypolicy.
*/}}
{{- define "podsecuritypolicy.apiVersion" -}}
{{- if semverCompare "<1.10-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "policy/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "elasticsearch.curator.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.curator.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "elasticsearch.curator.serviceAccountName" -}}
{{- if .Values.curator.serviceAccount.create -}}
    {{ default (include "elasticsearch.curator.fullname" .) .Values.curator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.curator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper ES curator image name
*/}}
{{- define "elasticsearch.curator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.curator.image "global" .Values.global) }}
{{- end -}}
