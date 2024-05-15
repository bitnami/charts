{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Get the user defined LoadBalancerIP for this release.
Note, returns 127.0.0.1 if using ClusterIP.
*/}}
{{- define "mediawiki.serviceIP" -}}
{{- if eq .Values.service.type "ClusterIP" -}}
127.0.0.1
{{- else -}}
{{- .Values.service.loadBalancerIP | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Gets the host to be used for this application.
If not using ClusterIP, or if a host or LoadBalancerIP is not defined, the value will be empty.
When using Ingress, it will be set to the Ingress hostname.
*/}}
{{- define "mediawiki.host" -}}
{{- $host := .Values.mediawikiHost | default "" -}}
{{- if .Values.ingress.enabled }}
{{- $host := .Values.ingress.hostname | default "" -}}
{{- end -}}
{{- default (include "mediawiki.serviceIP" .) $host -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mediawiki.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Mediawiki image name
*/}}
{{- define "mediawiki.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "mediawiki.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mediawiki.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image) "global" .Values.global) -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "mediawiki.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Hostname
*/}}
{{- define "mediawiki.databaseHost" -}}
{{- if .Values.mariadb.enabled }}
    {{- if eq .Values.mariadb.architecture "replication" }}
        {{- printf "%s-%s" (include "mediawiki.mariadb.fullname" .) "primary" | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "mediawiki.mariadb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "mediawiki.databasePort" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Database Name
*/}}
{{- define "mediawiki.databaseName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "mediawiki.databaseUser" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Secret Name
*/}}
{{- define "mediawiki.databaseSecretName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" (include "mediawiki.mariadb.fullname" .) -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "mediawiki.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- end -}}

{{/*
Get the credentials Secret
*/}}
{{- define "mediawiki.secretName" -}}
{{- if .Values.mediawikiSecret -}}
    {{- printf "%s" (tpl .Values.mediawikiSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a Secret object should be created
*/}}
{{- define "mediawiki.createSecret" -}}
{{- if .Values.mediawikiSecret -}}
{{- else -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of password and existing Secret mutually exclusive
*/}}
{{- define "mediawiki.validateValues.passwordSecretMutExclusive" -}}
{{- if and .Values.mediawikiPassword .Values.mediawikiSecret -}}
mediawiki: mediawikiSecret
    You cannot provide both mediawikiPassword and mediawikiSecret
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "mediawiki.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "mediawiki.validateValues.passwordSecretMutExclusive" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
