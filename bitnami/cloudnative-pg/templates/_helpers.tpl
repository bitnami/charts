{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "cloudnative-pg.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.operator.image .Values.operator.postgresqlImage .Values.pluginBarmanCloud.image .Values.pluginBarmanCloud.sidecarImage ) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Name for the env var PULL_SECRET_NAME
Note: This env var only allows one pull secret, so we will use the first one returned by common.images.pullSecrets
*/}}
{{- define "cloudnative-pg.operator.imagePullSecret" -}}
{{- $pullSecretsYaml := include "common.images.pullSecrets" (dict "images" (list .Values.operator.image) "global" .Values.global) | fromYaml -}}
{{- if $pullSecretsYaml }}
{{- print (index $pullSecretsYaml.imagePullSecrets 0).name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper cloudnative-pg Operator image name
*/}}
{{- define "cloudnative-pg.operator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.operator.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper PostgreSQL image name
*/}}
{{- define "cloudnative-pg.postgresql.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.operator.postgresqlImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Operator fullname
*/}}
{{- define "cloudnative-pg.operator.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "operator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Operator fullname with namespace
*/}}
{{- define "cloudnative-pg.operator.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "operator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use (cloudnative-pg Operator)
*/}}
{{- define "cloudnative-pg.operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create -}}
    {{ default (include "cloudnative-pg.operator.fullname" .) .Values.operator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.operator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (cloudnative-pg Operator)
*/}}
{{- define "cloudnative-pg.operator.useConfigMap" -}}
{{- if or .Values.operator.configuration .Values.operator.existingConfigMap -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (cloudnative-pg Operator)
*/}}
{{- define "cloudnative-pg.operator.useSecret" -}}
{{- if or .Values.operator.secretConfiguration .Values.operator.existingSecret -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get the configuration secret.
*/}}
{{- define "cloudnative-pg.operator.secretName" -}}
{{- if .Values.operator.existingSecret -}}
    {{- tpl .Values.operator.existingSecret $ -}}
{{- else }}
    {{- include "cloudnative-pg.operator.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
Get the configuration configmap.
*/}}
{{- define "cloudnative-pg.operator.configmapName" -}}
{{- if .Values.operator.existingConfigMap -}}
    {{- tpl .Values.operator.existingConfigMap $ -}}
{{- else }}
    {{- include "cloudnative-pg.operator.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Plugin Barman Cloud fullname
*/}}
{{- define "cloudnative-pg.plugin-barman-cloud.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "plugin-barman-cloud" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper cloudnative-pg Operator image name
*/}}
{{- define "cloudnative-pg.plugin-barman-cloud.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.pluginBarmanCloud.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper PostgreSQL image name
*/}}
{{- define "cloudnative-pg.plugin-barman-cloud.sidecar.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.pluginBarmanCloud.sidecarImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Plugin Barman Cloud fullname with namespace
*/}}
{{- define "cloudnative-pg.plugin-barman-cloud.fullname.namespace" -}}
{{- printf "%s-%s" (include "common.names.fullname.namespace" .) "plugin-barman-cloud" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Plugin Barman Cloud client secret
*/}}
{{- define "cloudnative-pg.plugin-barman-cloud.tlsClientSecretName" -}}
{{- if .Values.pluginBarmanCloud.tls.client.existingSecret -}}
{{- tpl .Values.pluginBarmanCloud.tls.client.existingSecret $ -}}
{{- else -}}
{{- printf "%s-client-crt" (include "cloudnative-pg.plugin-barman-cloud.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Plugin Barman Cloud server secret
*/}}
{{- define "cloudnative-pg.plugin-barman-cloud.tlsServerSecretName" -}}
{{- if .Values.pluginBarmanCloud.tls.server.existingSecret -}}
{{- tpl .Values.pluginBarmanCloud.tls.server.existingSecret $ -}}
{{- else -}}
{{- printf "%s-server-crt" (include "cloudnative-pg.plugin-barman-cloud.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (cloudnative-pg Plugin Barman Cloud)
*/}}
{{- define "cloudnative-pg.plugin-barman-cloud.serviceAccountName" -}}
{{- if .Values.pluginBarmanCloud.serviceAccount.create -}}
    {{ default (include "cloudnative-pg.plugin-barman-cloud.fullname" .) .Values.pluginBarmanCloud.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.pluginBarmanCloud.serviceAccount.name }}
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
{{- if and .Values.operator.configuration .Values.operator.existingConfigMap -}}
cloudnative-pg: Cannot specify configuration and existingConfigMap at the same time
{{- end -}}
{{- end -}}

{{/*
Function to validate the secret settings
*/}}
{{- define "cloudnative-pg.validateValues.secret" -}}
{{- if and .Values.operator.secretConfiguration .Values.operator.existingSecret -}}
cloudnative-pg: Cannot specify secretConfiguration and existingSecret at the same time
{{- end -}}
{{- end -}}
