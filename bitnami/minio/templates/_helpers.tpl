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
{{- $registryName := coalesce .Values.global.imageRegistry .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the proper MinIO Client image name
*/}}
{{- define "minio.clientImage" -}}
{{- $registryName := coalesce .Values.global.imageRegistry .Values.clientImage.registry -}}
{{- $repositoryName := .Values.clientImage.repository -}}
{{- $tag := .Values.clientImage.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "minio.imagePullSecrets" -}}
{{- $imagePullSecrets := coalesce .Values.global.imagePullSecrets .Values.image.pullSecrets -}}
{{- if $imagePullSecrets }}
{{- range $imagePullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return MinIO accessKey
*/}}
{{- define "minio.accessKey" -}}
{{- $accessKey := coalesce .Values.global.minio.accessKey .Values.accessKey.password -}}
{{- if $accessKey }}
    {{- $accessKey -}}
{{- else if (not .Values.accessKey.forcePassword) }}
    {{- randAlphaNum 10 -}}
{{- else -}}
    {{ required "An Access Key is required!" .Values.accessKey.password }}
{{- end -}}
{{- end -}}

{{/*
Return MinIO secretKey
*/}}
{{- define "minio.secretKey" -}}
{{- $secretKey := coalesce .Values.global.minio.secretKey .Values.secretKey.password -}}
{{- if $secretKey }}
    {{- $secretKey -}}
{{- else if (not .Values.secretKey.forcePassword) }}
    {{- randAlphaNum 40 -}}
{{- else -}}
    {{ required "A Secret Key is required!" .Values.secretKey.password }}
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
Compile all warnings into a single message, and call fail.
*/}}
{{- define "minio.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "minio.validateValues.mode" .) -}}
{{- $messages := append $messages (include "minio.validateValues.replicaCount" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of MinIO - must provide a valid mode ("distributed" or "standalone") */}}
{{- define "minio.validateValues.mode" -}}
{{- if and (ne .Values.mode "distributed") (ne .Values.mode "standalone") -}}
minio: mode
    Invalid mode selected. Valid values are "distributed" and
    "standalone". Please set a valid mode (--set mode="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of MinIO - number of replicas must be even, greater than 4 and lower than 32 */}}
{{- define "minio.validateValues.replicaCount" -}}
{{- $replicaCount := int .Values.statefulset.replicaCount }}
{{- if and (eq .Values.mode "distributed") (or (eq (mod $replicaCount 2) 1) (lt $replicaCount 4) (gt $replicaCount 32)) -}}
minio: replicaCount
    Number of replicas must be even, greater than 4 and lower than 32!!
    Please set a valid number of replicas (--set statefulset.replicaCount=X)
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "minio.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image.repository) (not (.Values.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image.repository }}:{{ .Values.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- if and (contains "bitnami/" .Values.clientImage.repository) (not (.Values.clientImage.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.clientImage.repository }}:{{ .Values.clientImage.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- end -}}
