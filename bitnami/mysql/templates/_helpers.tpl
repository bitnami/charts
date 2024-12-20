{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{- define "mysql.primary.fullname" -}}
{{- if eq .Values.architecture "replication" }}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.primary.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{- define "mysql.secondary.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.secondary.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper MySQL image name
*/}}
{{- define "mysql.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper metrics image name
*/}}
{{- define "mysql.metrics.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "mysql.volumePermissions.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "mysql.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "global" .Values.global) }}
{{- end -}}

{{/*
Get the initialization scripts ConfigMap name.
*/}}
{{- define "mysql.initdbScriptsCM" -}}
{{- if .Values.initdbScriptsConfigMap -}}
    {{- printf "%s" (tpl .Values.initdbScriptsConfigMap $) -}}
{{- else -}}
    {{- printf "%s-init-scripts" (include "mysql.primary.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the startdb scripts ConfigMap name.
*/}}
{{- define "mysql.startdbScriptsCM" -}}
{{- if .Values.startdbScriptsConfigMap -}}
    {{- printf "%s" (tpl .Values.startdbScriptsConfigMap $) -}}
{{- else -}}
    {{- printf "%s-start-scripts" (include "mysql.primary.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
 Returns the proper service account name depending if an explicit service account name is set
 in the values file. If the name is not set it will default to either mysql.fullname if serviceAccount.create
 is true or default otherwise.
*/}}
{{- define "mysql.serviceAccountName" -}}
    {{- if .Values.serviceAccount.create -}}
        {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
    {{- else -}}
        {{ default "default" .Values.serviceAccount.name }}
    {{- end -}}
{{- end -}}

{{/*
Return the configmap with the MySQL Primary configuration
*/}}
{{- define "mysql.primary.configmapName" -}}
{{- if .Values.primary.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.primary.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s" (include "mysql.primary.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created for MySQL Secondary
*/}}
{{- define "mysql.primary.createConfigmap" -}}
{{- if and .Values.primary.configuration (not .Values.primary.existingConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the configmap with the MySQL Primary configuration
*/}}
{{- define "mysql.secondary.configmapName" -}}
{{- if .Values.secondary.existingConfigmap -}}
    {{- printf "%s" (tpl .Values.secondary.existingConfigmap $) -}}
{{- else -}}
    {{- printf "%s" (include "mysql.secondary.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created for MySQL Secondary
*/}}
{{- define "mysql.secondary.createConfigmap" -}}
{{- if and (eq .Values.architecture "replication") .Values.secondary.configuration (not .Values.secondary.existingConfigmap) }}
    {{- true -}}
{{- else -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret with MySQL credentials
*/}}
{{- define "mysql.secretName" -}}
    {{- if .Values.auth.existingSecret -}}
        {{- printf "%s" (tpl .Values.auth.existingSecret $) -}}
    {{- else -}}
        {{- printf "%s" (include "common.names.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for MySQL
*/}}
{{- define "mysql.createSecret" -}}
{{- if and (not .Values.auth.existingSecret) (not .Values.auth.customPasswordFiles) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for MySQL
*/}}
{{- define "mysql.createPreviousSecret" -}}
{{- if and .Values.passwordUpdateJob.previousPasswords.rootPassword (not .Values.passwordUpdateJob.previousPasswords.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret with previous MySQL credentials
*/}}
{{- define "mysql.update-job.previousSecretName" -}}
    {{- if .Values.passwordUpdateJob.previousPasswords.existingSecret -}}
        {{- /* The secret with the new password is managed externally */ -}}
        {{- tpl .Values.passwordUpdateJob.previousPasswords.existingSecret $ -}}
    {{- else if .Values.passwordUpdateJob.previousPasswords.rootPassword -}}
        {{- /* The secret with the new password is managed externally */ -}}
        {{- printf "%s-previous-secret" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- /* The secret with the new password is managed by the helm chart. We use the current secret name as it has the old password */ -}}
        {{- include "common.names.fullname" . -}}
    {{- end -}}
{{- end -}}

{{/*
Return the secret with new MySQL credentials
*/}}
{{- define "mysql.update-job.newSecretName" -}}
    {{- if and (not .Values.passwordUpdateJob.previousPasswords.existingSecret) (not .Values.passwordUpdateJob.previousPasswords.rootPassword) -}}
        {{- /* The secret with the new password is managed by the helm chart. We create a new secret as the current one has the old password */ -}}
        {{- printf "%s-new-secret" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- /* The secret with the new password is managed externally */ -}}
        {{- include "mysql.secretName" . -}}
    {{- end -}}
{{- end -}}

{{/*
Return the MySQL TLS credentials secret
*/}}
{{- define "mysql.tlsSecretName" -}}
{{- if .Values.tls.existingSecret -}}
    {{- print (tpl .Values.tls.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-crt" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "mysql.tlsCACert" -}}
{{- if or (eq .Values.tls.autoGenerated.engine "helm") (and (not .Values.tls.autoGenerated.enabled) (empty .Values.tls.existingSecret) .Values.tls.ca) -}}
    {{- printf "/opt/bitnami/mysql/certs/%s" "ca.crt" -}}
{{- else }}
    {{- ternary "" (printf "/opt/bitnami/mysql/certs/%s" .Values.tls.certCAFilename) (empty .Values.tls.certCAFilename) }}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "mysql.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "mysql.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
