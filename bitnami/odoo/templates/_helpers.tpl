{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "odoo.name" -}}
{{- include "common.names.name" . -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "odoo.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "odoo.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "odoo.chart" -}}
{{- include "common.names.chart" . -}}
{{- end -}}

{{/*
Return the proper Odoo image name
*/}}
{{- define "odoo.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "odoo.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "odoo.storageClass" -}}
{{- include "common.storage.class" (dict "persistence" .Values.persistence "global" .Values.global) -}}
{{- end -}}

{{/*
Return the Postgresql hostname
*/}}
{{- define "odoo.databaseHost" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" (include "odoo.postgresql.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgresql port
*/}}
{{- define "odoo.databasePort" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "5432" | quote -}}
{{- else -}}
    {{- .Values.externalDatabase.port | quote -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgresql database name
*/}}
{{- define "odoo.databaseName" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgresql user
*/}}
{{- define "odoo.databaseUser" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Secret Name
*/}}
{{- define "odoo.databaseSecretName" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.postgresql.auth.existingSecret }}
        {{- printf "%s" .Values.postgresql.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "odoo.postgresql.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret }}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Odoo credential secret name
*/}}
{{- define "odoo.secretName" -}}
{{- coalesce .Values.existingSecret (include "odoo.fullname" .) -}}
{{- end -}}

{{/*
Return the SMTP Secret Name
*/}}
{{- define "odoo.smtpSecretName" -}}
{{- coalesce .Values.smtpExistingSecret (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "odoo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "odoo.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
