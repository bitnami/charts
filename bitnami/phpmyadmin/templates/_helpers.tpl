{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper PHPMyAdmin image name
*/}}
{{- define "phpmyadmin.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "phpmyadmin.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "phpmyadmin.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image) "global" .Values.global) -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "phpmyadmin.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "phpmyadmin.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified database name if the database is part of the same release than phpmyadmin.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "phpmyadmin.dbfullname" -}}
{{- printf "%s-%s" .Release.Name .Values.db.chartName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "phpmyadmin.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "phpmyadmin.validateValues.db.ssl" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of phpMyAdmin - must provide a valid database ssl configuration */}}
{{- define "phpmyadmin.validateValues.db.ssl" -}}
{{- if and .Values.db.enableSsl (empty .Values.db.ssl.clientKey) (empty .Values.db.ssl.clientCertificate) (empty .Values.db.ssl.caCertificate) -}}
phpMyAdmin: db.ssl
    Invalid database ssl configuration. You enabled SSL for the connection
    between phpMyAdmin and the database but no key/certificates were provided
    (--set db.ssl.clientKey="xxxx", --set db.ssl.clientCertificate="yyyy")
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "phpmyadmin.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- end -}}
