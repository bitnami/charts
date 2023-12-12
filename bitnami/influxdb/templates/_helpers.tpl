{{/*
Copyright VMware, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}


{{/*
Return the proper InfluxDB&trade; image name
*/}}
{{- define "influxdb.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper init container volume-permissions image name
*/}}
{{- define "influxdb.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper gcloud-sdk image name
*/}}
{{- define "gcloudSdk.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.backup.uploadProviders.google.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper azure-cli image name
*/}}
{{- define "azureCli.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.backup.uploadProviders.azure.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper aws-cli image name
*/}}
{{- define "awsCli.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.backup.uploadProviders.aws.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "influxdb.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image .Values.backup.uploadProviders.google.image .Values.backup.uploadProviders.azure.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "influxdb.serviceAccountName" -}}
{{- if or .Values.serviceAccount.enabled .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the InfluxDB&trade; credentials secret.
*/}}
{{- define "influxdb.secretName" -}}
{{- if .Values.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.auth.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the InfluxDB&trade; configuration configmap.
*/}}
{{- define "influxdb.configmapName" -}}
{{- if .Values.influxdb.existingConfiguration -}}
    {{- printf "%s" (tpl .Values.influxdb.existingConfiguration $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the InfluxDB&trade; PVC name.
*/}}
{{- define "influxdb.claimName" -}}
{{- if .Values.persistence.existingClaim }}
    {{- printf "%s" (tpl .Values.persistence.existingClaim $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the InfluxDB&trade; initialization scripts configmap.
*/}}
{{- define "influxdb.initdbScriptsConfigmapName" -}}
{{- if .Values.influxdb.initdbScriptsCM -}}
    {{- printf "%s" (tpl .Values.influxdb.initdbScriptsCM $) -}}
{{- else -}}
    {{- printf "%s-initdb-scripts" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the InfluxDB&trade; initialization scripts secret.
*/}}
{{- define "influxdb.initdbScriptsSecret" -}}
{{- printf "%s" (tpl .Values.influxdb.initdbScriptsSecret $) -}}
{{- end -}}

{{- /*
Helper template for determining which persistence settings to use for backup PVC.
Allows backwards-compatibility for users that have not defined a backups.persistence dict in their values files.
*/}}
{{- define "influxdb.backup.pvc" }}
{{- $ := index . 0 }}
{{- $persistence := index . 1 }}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ include "common.names.fullname" $ }}-backups
  namespace: {{ $.Release.Namespace | quote }}
  labels: {{- include "common.labels.standard" ( dict "customLabels" $.Values.commonLabels "context" $ ) | nindent 4 }}
    app.kubernetes.io/component: influxdb
  {{- if or $persistence.annotations $.Values.commonAnnotations }}
  {{- $annotations := include "common.tplvalues.merge" ( dict "values" ( list $persistence.annotations $.Values.commonAnnotations ) "context" $ ) }}
  annotations: {{- include "common.tplvalues.render" ( dict "value" $annotations "context" $) | nindent 4 }}
  {{- end }}
spec:
  accessModes:
  {{- range $persistence.accessModes }}
    - {{ . | quote }}
  {{- end }}
  resources:
    requests:
      storage: {{ $persistence.size | quote }}
  {{- include "common.storage.class" ( dict "persistence" $persistence "global" $) | nindent 2 }}
{{- end }}
