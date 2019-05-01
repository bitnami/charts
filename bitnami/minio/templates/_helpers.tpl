{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "minio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "minio.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "minio.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper MinIO image name
*/}}
{{- define "minio.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper MinIO Client image name
*/}}
{{- define "minio.clientImage" -}}
{{- $registryName := .Values.clientImage.registry -}}
{{- $repositoryName := .Values.clientImage.repository -}}
{{- $tag := .Values.clientImage.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "minio.imagePullSecrets" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
Also, we can not use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- else if .Values.image.pullSecrets }}
imagePullSecrets:
{{- range .Values.image.pullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Return MinIO accessKey
*/}}
{{- define "minio.accessKey" -}}
{{- if .Values.global.minio.accessKey }}
    {{- if .Values.global.minio.accessKey.password }}
        {{- .Values.global.minio.accessKey.password -}}
    {{- else if (not .Values.global.minio.accessKey.forcePassword) }}
        {{- randAlphaNum 10 -}}
    {{- else -}}
        {{ required "An Access Key is required!" .Values.global.minio.accessKey.password }}
    {{- end -}}
{{- else if .Values.accessKey -}}
    {{- if .Values.accessKey.password }}
        {{- .Values.accessKey.password -}}
    {{- else if (not .Values.accessKey.forcePassword) }}
        {{- randAlphaNum 10 -}}
    {{- else -}}
        {{ required "An Access Key is required!" .Values.accessKey.password }}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return MinIO secretKey
*/}}
{{- define "minio.secretKey" -}}
{{- if .Values.global.minio.secretKey }}
    {{- if .Values.global.minio.secretKey.password }}
        {{- .Values.global.minio.secretKey.password -}}
    {{- else if (not .Values.global.minio.secretKey.forcePassword) }}
        {{- randAlphaNum 40 -}}
    {{- else -}}
        {{ required "A Secret Key is required!" .Values.global.minio.secretKey.password }}
    {{- end -}}
{{- else if .Values.secretKey -}}
    {{- if .Values.secretKey.password }}
        {{- .Values.secretKey.password -}}
    {{- else if (not .Values.secretKey.forcePassword) }}
        {{- randAlphaNum 40 -}}
    {{- else -}}
        {{ required "A Secret Key is required!" .Values.secretKey.password }}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get the credentials secret.
*/}}
{{- define "minio.secretName" -}}
{{- if .Values.global.minio.existingSecret }}
    {{- printf "%s" .Values.global.minio.existingSecret -}}
{{- else if .Values.existingSecret -}}
    {{- printf "%s" .Values.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "minio.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "minio.createSecret" -}}
{{- if .Values.global.minio.existingSecret }}
{{- else if .Values.existingSecret -}}
{{- else -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for networkpolicy.
*/}}
{{- define "networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <1.7-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}
