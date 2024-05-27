{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redmine.mariadb.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mariadb" "chartValues" .Values.mariadb "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redmine.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
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
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.certificates.image) "global" .Values.global) -}}
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
{{- default (include "common.names.fullname" .) .Values.existingSecret -}}
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
{{- if and (eq .Values.databaseType "mariadb") .Values.mariadb.enabled -}}
    {{- include "redmine.mariadb.fullname" . | quote -}}
{{- else if and (eq .Values.databaseType "postgresql") .Values.postgresql.enabled -}}
    {{- include "redmine.postgresql.fullname" . | quote  -}}
{{- else }}
    {{- .Values.externalDatabase.host | quote }}
{{- end -}}
{{- end -}}

{{/*
Return the database port for Redmine
*/}}
{{- define "redmine.database.port" -}}
{{- if and (eq .Values.databaseType "mariadb") .Values.mariadb.enabled -}}
    {{- print "3306" -}}
{{- else if and (eq .Values.databaseType "postgresql") .Values.postgresql.enabled -}}
    {{- print "5432" -}}
{{- else }}
    {{- .Values.externalDatabase.port }}
{{- end -}}
{{- end -}}

{{/*
Return the database name for Redmine
*/}}
{{- define "redmine.database.name" -}}
{{- if and (eq .Values.databaseType "mariadb") .Values.mariadb.enabled -}}
    {{- .Values.mariadb.auth.database | quote }}
{{- else if and (eq .Values.databaseType "postgresql") .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.auth }}
            {{- coalesce .Values.global.postgresql.auth.database .Values.postgresql.auth.database | quote -}}
        {{- else -}}
            {{- .Values.postgresql.auth.database | quote -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.database | quote -}}
    {{- end -}}
{{- else }}
    {{- .Values.externalDatabase.database | quote }}
{{- end -}}
{{- end -}}

{{/*
Return the database username for Redmine
*/}}
{{- define "redmine.database.username" -}}
{{- if and (eq .Values.databaseType "mariadb") .Values.mariadb.enabled -}}
    {{- .Values.mariadb.auth.username | quote }}
{{- else if and (eq .Values.databaseType "postgresql") .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.auth }}
            {{- coalesce .Values.global.postgresql.auth.username .Values.postgresql.auth.username | quote -}}
        {{- else -}}
            {{- .Values.postgresql.auth.username | quote -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.username | quote -}}
    {{- end -}}
{{- else }}
    {{- .Values.externalDatabase.user | quote }}
{{- end -}}
{{- end -}}

{{/*
Return the name of the database secret with its credentials
*/}}
{{- define "redmine.database.secretName" -}}
{{- if and (eq .Values.databaseType "mariadb") .Values.mariadb.enabled -}}
    {{- if .Values.mariadb.existingSecret -}}
        {{- printf "%s" .Values.mariadb.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "redmine.mariadb.fullname" .) -}}
    {{- end -}}
{{- else if and (eq .Values.databaseType "postgresql") .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql }}
        {{- if .Values.global.postgresql.auth }}
            {{- if .Values.global.postgresql.auth.existingSecret }}
                {{- tpl .Values.global.postgresql.auth.existingSecret $ -}}
            {{- else -}}
                {{- default (include "redmine.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "redmine.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "redmine.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
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
Add environment variables to configure database values
*/}}
{{- define "redmine.database.secretKey" -}}
{{- if and (eq .Values.databaseType "mariadb") .Values.mariadb.enabled -}}
    {{- print "mariadb-password" -}}
{{- else if and (eq .Values.databaseType "postgresql") .Values.postgresql.enabled -}}
    {{- print "password" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "password" -}}
        {{- end -}}
    {{- else -}}
        {{- if eq .Values.databaseType "mariadb" -}}
            {{- print "mariadb-password" -}}
        {{- else -}}
            {{- print "password" -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}
