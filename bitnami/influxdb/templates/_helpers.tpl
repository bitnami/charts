{{/*
Copyright Broadcom, Inc. All Rights Reserved.
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
Return the InfluxDB&trade; backup PVC name.
*/}}
{{- define "influxdb.backup.claimName" -}}
{{- if and .Values.backup.persistence.ownConfig .Values.backup.persistence.existingClaim }}
    {{- printf "%s" (tpl .Values.backup.persistence.existingClaim $) -}}
{{- else -}}
    {{- printf "%s-backups" (include "common.names.fullname" .) -}}
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
