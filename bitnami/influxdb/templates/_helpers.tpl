{{/* vim: set filetype=mustache: */}}


{{/*
Return the proper InfluxDB&trade; image name
*/}}
{{- define "influxdb.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper InfluxDB Relay&trade; image name
*/}}
{{- define "influxdb.relay.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.relay.image "global" .Values.global) }}
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
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.relay.image .Values.volumePermissions.image .Values.backup.uploadProviders.google.image .Values.backup.uploadProviders.azure.image) "global" .Values.global) }}
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

{{/*
Return the InfluxDB&trade; configuration configmap.
*/}}
{{- define "influxdb.relay.configmapName" -}}
{{- if .Values.relay.existingConfiguration -}}
    {{- printf "%s" (tpl .Values.relay.existingConfiguration $) -}}
{{- else -}}
    {{- printf "%s-relay" (include "common.names.fullname" .) -}}
{{- end -}}
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

{{/* Validate values of InfluxDB&trade; - must provide a valid architecture */}}
{{- define "influxdb.validateValues.architecture" -}}
{{- if and (ne .Values.architecture "standalone") (ne .Values.architecture "high-availability") -}}
influxdb: architecture
    Invalid architecture selected. Valid values are "standalone" and
    "high-availability". Please set a valid architecture (--set architecture="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of InfluxDB&trade; - number of replicas */}}
{{- define "influxdb.validateValues.replicaCount" -}}
{{- $replicaCount := int .Values.influxdb.replicaCount }}
{{- if and (eq .Values.architecture "standalone") (gt $replicaCount 1) -}}
influxdb: replicaCount
    The standalone architecture doesn't allow to run more than 1 replica.
    Please set a valid number of replicas (--set influxdb.replicaCount=1) or
    use the "high-availability" architecture (--set architecture="high-availability")
{{- end -}}
{{- end -}}
