{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper OAuth2 Proxy image name
*/}}
{{- define "oauth2-proxy.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "oauth2-proxy.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "oauth2-proxy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "oauth2-proxy.redis.fullname" -}}
{{- printf "%s-redis" (default .Release.Name .Values.redis.nameOverride) -}}
{{- end -}}

{{- define "oauth2-proxy.configmapName" -}}
{{- if .Values.configuration.existingConfigmap -}}
{{- .Values.configuration.existingConfigmap -}}
{{- else -}}
{{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{- define "oauth2-proxy.secretName" -}}
{{- if .Values.configuration.existingSecret -}}
{{- .Values.configuration.existingSecret -}}
{{- else -}}
{{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{- define "oauth2-proxy.authenticatedEmailsSecret" -}}
{{- if .Values.configuration.authenticatedEmailsFile.existingSecret -}}
{{- .Values.configuration.authenticatedEmailsFile.existingSecret -}}
{{- else -}}
{{- printf "%s-access-list" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "oauth2-proxy.httpasswdSecret" -}}
{{- if .Values.configuration.htpasswdFile.existingSecret -}}
{{- .Values.configuration.htpasswdFile.existingSecret -}}
{{- else -}}
{{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{- define "oauth2-proxy.googleSecret" -}}
{{- if .Values.configuration.google.existingSecret -}}
{{- .Values.configuration.google.existingSecret -}}
{{- else -}}
{{- printf "%s-google" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "oauth2-proxy.redis.url" -}}
{{- if .Values.redis.enabled -}}
{{- if .Values.redis.sentinel.enabled -}}
{{- $port := printf "%v" .Values.redis.sentinel.service.port -}}
{{- printf "redis://%s:%s" (include "oauth2-proxy.redis.fullname" .) $port -}}
{{- else -}}
{{- $port := printf "%v" .Values.redis.master.service.port -}}
{{- printf "redis://%s-master:%s" (include "oauth2-proxy.redis.fullname" .) $port -}}
{{- end -}}
{{- else if .Values.externalRedis.host -}}
{{- $port := printf "%v" .Values.externalRedis.port -}}
{{- printf "redis://%s:%s" .Values.externalRedis.host $port -}}
{{- end -}}
{{- end -}}

{{- define "oauth2-proxy.redis.sentinelUrl" -}}
{{- $port := printf "%v" .Values.redis.sentinel.service.sentinelPort -}}
{{- printf "redis://%s:%s" (include "oauth2-proxy.redis.fullname" .) $port -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "oauth2-proxy.redis.secretName" -}}
{{- if .Values.redis.enabled }}
{{- if .Values.redis.auth.existingSecret -}}
{{- .Values.redis.auth.existingSecret -}}
{{- else -}}
{{- include "oauth2-proxy.redis.fullname" . -}}
{{- end -}}
{{- else if .Values.externalRedis.existingSecret }}
{{- .Values.externalRedis.existingSecret -}}
{{- else -}}
{{- printf "%s-external-redis" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password key to be retrieved from Redis&reg; secret.
*/}}
{{- define "oauth2-proxy.redis.secretPasswordKey" -}}
{{- if and .Values.redis.enabled .Values.redis.auth.existingSecret .Values.redis.auth.existingSecretPasswordKey -}}
{{- printf "%s" .Values.redis.auth.existingSecretPasswordKey -}}
{{- else if and (not .Values.redis.enabled) .Values.externalRedis.existingSecret .Values.externalRedis.existingSecretPasswordKey -}}
{{- printf "%s" .Values.externalRedis.existingSecretPasswordKey -}}
{{- else -}}
{{- printf "redis-password" -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "oauth2-proxy.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "oauth2-proxy.validateValues.redis" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Redis - clusterName */}}
{{- define "oauth2-proxy.validateValues.redis" -}}
{{- if and .Values.redis.enabled .Values.externalRedis.host -}}
oauth2-proxy: BothRedis
    The redis sub-chart was enabled and an external Redis host was set at the same time. Please set only one of the following:

        a) Enable the redis sub-chart with redis.enabled
        b) Set redis.enabled=false and set the externalRedis section
{{- end -}}
{{- end -}}
