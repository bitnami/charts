{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redmine.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redmine.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Redmine image name
*/}}
{{- define "redmine.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "redmine.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.mailReceiver.image .Values.volumePermissions.image .Values.certificates.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return  the proper Storage Class
*/}}
{{- define "redmine.storageClass" -}}
{{- include "common.storage.class" (dict "persistence" .Values.persistence "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "redmine.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
{{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the name of the Secret used to store the passwords
*/}}
{{- define "redmine.secretName" -}}
{{- if .Values.existingSecret -}}
{{ .Values.existingSecret }}
{{- else -}}
{{ include "common.names.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "redmine.mailReceiver.name" -}}
{{- printf "%s-mail-receiver" (include "common.names.name" .) -}}
{{- end -}}

{{/*
Create a default fully qualified mail receiver app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redmine.mailReceiver.fullname" -}}
{{- printf "%s-mail-receiver" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the proper Redmine mail Receiver image name
*/}}
{{- define "redmine.mailReceiver.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.mailReceiver.image "global" .Values.global) }}
{{- end -}}

{{/*
Return whether to use the external DB or the built-in subcharts
*/}}
{{- define "redmine.useExternalDB" -}}
{{- if or (and (eq .Values.databaseType "mariadb") (not .Values.mariadb.enabled)) (and (eq .Values.databaseType "postgresql") (not .Values.postgresql.enabled)) -}}
  {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return whether to create an external secret containing the
credentials for the external database or not
*/}}
{{- define "redmine.createExternalDBSecret" -}}
{{- if and (include "redmine.useExternalDB" .) (not .Values.externalDatabase.existingSecret) -}}
  {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the database host for Redmine
*/}}
{{- define "redmine.database.host" -}}
{{- if and (eq .Values.databaseType "mariadb") (.Values.mariadb.enabled) -}}
    {{- printf "%s" (include "redmine.mariadb.fullname" .) -}}
{{- else if and (eq .Values.databaseType "postgresql") (.Values.postgresql.enabled) -}}
    {{- printf "%s" (include "redmine.postgresql.fullname" .) -}}
{{- else }}
    {{- .Values.externalDatabase.host | quote }}
{{- end -}}
{{- end -}}

{{/*
Return the database name for Redmine
*/}}
{{- define "redmine.database.name" -}}
{{- if and (eq .Values.databaseType "mariadb") (.Values.mariadb.enabled) -}}
    {{- .Values.mariadb.auth.database | quote }}
{{- else if and (eq .Values.databaseType "postgresql") (.Values.postgresql.enabled) -}}
    {{- .Values.postgresql.postgresqlDatabase | quote }}
{{- else }}
    {{- .Values.externalDatabase.name | quote }}
{{- end -}}
{{- end -}}

{{/*
Return the database username for Redmine
*/}}
{{- define "redmine.database.username" -}}
{{- if and (eq .Values.databaseType "mariadb") (.Values.mariadb.enabled) -}}
    {{- .Values.mariadb.auth.username | quote }}
{{- else if and (eq .Values.databaseType "postgresql") (.Values.postgresql.enabled) -}}
    {{- .Values.postgresql.postgresqlUsername | quote }}
{{- else }}
    {{- .Values.externalDatabase.user | quote }}
{{- end -}}
{{- end -}}

{{/*
Return the name of the database secret with its credentials
*/}}
{{- define "redmine.database.secretName" -}}
{{- if and (eq .Values.databaseType "mariadb") (.Values.mariadb.enabled) -}}
    {{- if .Values.mariadb.existingSecret -}}
        {{- printf "%s" .Values.mariadb.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "redmine.mariadb.fullname" .) -}}
    {{- end -}}
{{- else if and (eq .Values.databaseType "postgresql") (.Values.postgresql.enabled) -}}
    {{- if .Values.postgresql.existingSecret -}}
        {{- printf "%s" .Values.postgresql.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "redmine.postgresql.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- printf "%s" .Values.externalDatabase.existingSecret -}}
    {{- else -}}
        {{- printf "%s-%s" (include "common.names.fullname" .) "externaldb" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "redmine.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}
