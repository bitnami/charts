{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "influxdb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "influxdb.fullname" -}}
{{- if .Values.fullnameOverride -}}
    {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{- $name := default .Chart.Name .Values.nameOverride -}}
    {{- if contains $name .Release.Name -}}
        {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "influxdb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "influxdb.labels" -}}
app.kubernetes.io/name: {{ include "influxdb.name" . }}
helm.sh/chart: {{ include "influxdb.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "influxdb.matchLabels" -}}
app.kubernetes.io/name: {{ include "influxdb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return the proper InfluxDB(TM) image name
*/}}
{{- define "influxdb.image" -}}
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
Return the proper InfluxDB Relay(TM) image name
*/}}
{{- define "influxdb.relay.image" -}}
{{- $registryName := .Values.relay.image.registry -}}
{{- $repositoryName := .Values.relay.image.repository -}}
{{- $tag := .Values.relay.image.tag | toString -}}
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
Return the proper init container volume-permissions image name
*/}}
{{- define "influxdb.volumePermissions.image" -}}
{{- $registryName := .Values.volumePermissions.image.registry -}}
{{- $repositoryName := .Values.volumePermissions.image.repository -}}
{{- $tag := .Values.volumePermissions.image.tag | toString -}}
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
Return the proper gcloud-sdk image name
*/}}
{{- define "gcloudSdk.image" -}}
{{- $registryName := .Values.backup.uploadProviders.google.image.registry -}}
{{- $repositoryName := .Values.backup.uploadProviders.google.image.repository -}}
{{- $tag := .Values.backup.uploadProviders.google.image.tag | toString -}}
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
Return the proper azure-cli image name
*/}}
{{- define "azureCli.image" -}}
{{- $registryName := .Values.backup.uploadProviders.azure.image.registry -}}
{{- $repositoryName := .Values.backup.uploadProviders.azure.image.repository -}}
{{- $tag := .Values.backup.uploadProviders.azure.image.tag | toString -}}
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
{{- define "influxdb.imagePullSecrets" -}}
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
    {{- else if or .Values.image.pullSecrets .Values.relay.image.pullSecrets .Values.volumePermissions.image.pullSecrets }}
imagePullSecrets:
        {{- range .Values.image.pullSecrets }}
  - name: {{ . }}
        {{- end }}
        {{- range .Values.relay.image.pullSecrets }}
  - name: {{ . }}
        {{- end }}
        {{- range .Values.volumePermissions.image.pullSecrets }}
  - name: {{ . }}
        {{- end }}
    {{- end -}}
{{- else if or .Values.image.pullSecrets .Values.relay.image.pullSecrets .Values.volumePermissions.image.pullSecrets }}
imagePullSecrets:
    {{- range .Values.image.pullSecrets }}
  - name: {{ . }}
    {{- end }}
    {{- range .Values.relay.image.pullSecrets }}
  - name: {{ . }}
    {{- end }}
    {{- range .Values.volumePermissions.image.pullSecrets }}
  - name: {{ . }}
    {{- end }}
{{- end -}}
{{- end -}}

{{/*
Return the InfluxDB(TM) credentials secret.
*/}}
{{- define "influxdb.secretName" -}}
{{- if .Values.existingSecret -}}
    {{- printf "%s" (tpl .Values.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "influxdb.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the InfluxDB(TM) configuration configmap.
*/}}
{{- define "influxdb.configmapName" -}}
{{- if .Values.influxdb.existingConfiguration -}}
    {{- printf "%s" (tpl .Values.influxdb.existingConfiguration $) -}}
{{- else -}}
    {{- printf "%s" (include "influxdb.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the InfluxDB(TM) PVC name.
*/}}
{{- define "influxdb.claimName" -}}
{{- if .Values.persistence.existingClaim }}
    {{- printf "%s" (tpl .Values.persistence.existingClaim $) -}}
{{- else -}}
    {{- printf "%s" (include "influxdb.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the InfluxDB(TM) initialization scripts configmap.
*/}}
{{- define "influxdb.initdbScriptsConfigmapName" -}}
{{- if .Values.influxdb.initdbScriptsCM -}}
    {{- printf "%s" (tpl .Values.influxdb.initdbScriptsCM $) -}}
{{- else -}}
    {{- printf "%s-initdb-scripts" (include "influxdb.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the InfluxDB(TM) initialization scripts secret.
*/}}
{{- define "influxdb.initdbScriptsSecret" -}}
{{- printf "%s" (tpl .Values.influxdb.initdbScriptsSecret $) -}}
{{- end -}}

{{/*
Return the InfluxDB(TM) configuration configmap.
*/}}
{{- define "influxdb.relay.configmapName" -}}
{{- if .Values.relay.existingConfiguration -}}
    {{- printf "%s" (tpl .Values.relay.existingConfiguration $) -}}
{{- else -}}
    {{- printf "%s-relay" (include "influxdb.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Storage Class for InfluxDB(TM)
*/}}
{{- define "influxdb.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.storageClass -}}
              {{- if (eq "-" .Values.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.storageClass -}}
        {{- if (eq "-" .Values.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for networkPolicy
*/}}
{{- define "influxdb.networkPolicy.apiVersion" -}}
{{- if semverCompare ">=1.4-0, <1.7-0" .Capabilities.KubeVersion.GitVersion -}}
"extensions/v1beta1"
{{- else if semverCompare "^1.7-0" .Capabilities.KubeVersion.GitVersion -}}
"networking.k8s.io/v1"
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "influxdb.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image.repository) (not (.Values.image.tag | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image.repository }}:{{ .Values.image.tag }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "influxdb.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "influxdb.validateValues.architecture" .) -}}
{{- $messages := append $messages (include "influxdb.validateValues.replicaCount" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of InfluxDB(TM) - must provide a valid architecture */}}
{{- define "influxdb.validateValues.architecture" -}}
{{- if and (ne .Values.architecture "standalone") (ne .Values.architecture "high-availability") -}}
influxdb: architecture
    Invalid architecture selected. Valid values are "standalone" and
    "high-availability". Please set a valid architecture (--set architecture="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of InfluxDB(TM) - number of replicas */}}
{{- define "influxdb.validateValues.replicaCount" -}}
{{- $replicaCount := int .Values.influxdb.replicaCount }}
{{- if and (eq .Values.architecture "standalone") (gt $replicaCount 1) -}}
influxdb: replicaCount
    The standalone architecture doesn't allow to run more than 1 replica.
    Please set a valid number of replicas (--set influxdb.replicaCount=1) or
    use the "high-availability" architecture (--set architecture="high-availability")
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "ingress.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}
