{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "cloudnative-pg.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.postgresqlImage ) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Name for the env var PULL_SECRET_NAME
Note: This env var only allows one pull secret, so we will use the first one returned by common.images.pullSecrets
*/}}
{{- define "cloudnative-pg.operator.imagePullSecret" -}}
{{- $pullSecretsYaml := include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) | fromYaml -}}
{{- if $pullSecretsYaml }}
{{- print (index $pullSecretsYaml.imagePullSecrets 0).name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper cloudnative-pg Operator image name
*/}}
{{- define "cloudnative-pg.operator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper PostgreSQL image name
*/}}
{{- define "cloudnative-pg.postgresql.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.postgresqlImage "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (cloudnative-pg Operator)
*/}}
{{- define "cloudnative-pg.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (cloudnative-pg Operator)
*/}}
{{- define "cloudnative-pg.useConfigMap" -}}
{{- if or .Values.configuration .Values.existingConfigMap -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (cloudnative-pg Operator)
*/}}
{{- define "cloudnative-pg.useSecret" -}}
{{- if or .Values.secretConfiguration .Values.existingSecret -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the configuration secret.
*/}}
{{- define "cloudnative-pg.secretName" -}}
{{- if .Values.existingSecret -}}
    {{- tpl .Values.existingSecret $ -}}
{{- else }}
    {{- include "common.names.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
Get the configuration configmap.
*/}}
{{- define "cloudnative-pg.configmapName" -}}
{{- if .Values.existingConfigMap -}}
    {{- tpl .Values.existingConfigMap $ -}}
{{- else }}
    {{- include "common.names.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
Validate values for cloudnative-pg.
*/}}
{{- define "cloudnative-pg.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "cloudnative-pg.validateValues.configmap" .) -}}
{{- $messages := append $messages (include "cloudnative-pg.validateValues.secret" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Function to validate the configmap settings
*/}}
{{- define "cloudnative-pg.validateValues.configmap" -}}
{{- if and .Values.configuration .Values.existingConfigMap -}}
cloudnative-pg: Cannot specify configuration and existingConfigMap at the same time
{{- end -}}
{{- end -}}

{{/*
Function to validate the secret settings
*/}}
{{- define "cloudnative-pg.validateValues.secret" -}}
{{- if and .Values.secretConfiguration .Values.existingSecret -}}
cloudnative-pg: Cannot specify secretConfiguration and existingSecret at the same time
{{- end -}}
{{- end -}}
