{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Create the name of the service account to use
*/}}
{{- define "gitlab-runner.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper gitlab-runner image name
*/}}
{{- define "gitlab-runner.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper gitlab-runner image name
*/}}
{{- define "gitlab-runner.session-server.fullname" -}}
{{ printf "%s-session-server" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "gitlab-runner.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image ) "context" $) -}}
{{- end -}}

{{/*
Name of the Runner Secret
*/}}
{{- define "gitlab-runner.secretName" -}}
{{- if .Values.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.existingSecret "context" $) -}}
{{- else -}}
    {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Name of the Runner ConfigMap
*/}}
{{- define "gitlab-runner.configmapName" -}}
{{- if .Values.existingConfigMap -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.existingConfigMap "context" $) -}}
{{- else -}}
    {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "gitlab-runner.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "gitlab-runner.validateValues.gitlabUrl" .) -}}
{{- $messages := append $messages (include "gitlab-runner.validateValues.runnerToken" .) -}}
{{- $messages := append $messages (include "gitlab-runner.validateValues.sessionServer" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of gitlab-runner - Missing Gitlab URL */}}
{{- define "gitlab-runner.validateValues.gitlabUrl" -}}
{{- if not .Values.gitlabUrl -}}
gitlab-runner: Missing Gitlab URL
    You need to specify an existing Gitlab installation using the gitlabUrl value
{{- end -}}
{{- end -}}

{{/* Validate values of gitlab-runner - Missing Runner Token */}}
{{- define "gitlab-runner.validateValues.runnerToken" -}}
{{- if not (coalesce .Values.runnerToken .Values.existingSecret) -}}
gitlab-runner: Missing Runner Token
    You need to specify a runner token connected to your Gitlab installation using either the runnnerToken or the existingSecret values.

    https://docs.gitlab.com/runner/register/
{{- end -}}
{{- end -}}

{{/* Validate values of gitlab-runner - Session server configuration */}}
{{- define "gitlab-runner.validateValues.sessionServer" -}}
{{- if and .Values.sessionServer.enabled (gt (.Values.replicaCount | int) 1) -}}
gitlab-runner: Incorrect Session Server configuration
    When enabling the session server the number of replicas must be 1
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "gitlab-runner.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- end -}}
