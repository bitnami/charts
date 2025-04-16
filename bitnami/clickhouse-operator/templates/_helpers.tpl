{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper ClickHouse Operator image name
*/}}
{{- define "clickhouse-operator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper ClickHouse image name
*/}}
{{- define "clickhouse-operator.clickhouse.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.clickHouseImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper ClickHouse Keeper image name
*/}}
{{- define "clickhouse-operator.keeper.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.keeperImage "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper ClickHouse Operator Metrics exporter image name
*/}}
{{- define "clickhouse-operator.metrics.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.metrics.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "clickhouse-operator.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.clickHouseImage .Values.keeperImage .Values.metrics.image) "context" $) -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "clickhouse-operator.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.clickHouseImage }}
{{- include "common.warnings.rollingTag" .Values.keeperImage }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "clickhouse-operator.serviceAccount.name" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the ClickHouse operator configuration configmap
*/}}
{{- define "clickhouse-operator.configmap.name" -}}
{{- if .Values.existingConfigmap -}}
    {{- print (tpl .Values.existingConfigmap $) -}}
{{- else -}}
    {{- print (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the ClickHouse Installation templates configmap
*/}}
{{- define "clickhouse-operator.chiTemplates.configmap.name" -}}
{{- if .Values.existingChiTemplatesConfigmap -}}
    {{- print (tpl .Values.existingChiTemplatesConfigmap $) -}}
{{- else -}}
    {{- printf "%s-chi-templates" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the ClickHouse Installation configd configmap
*/}}
{{- define "clickhouse-operator.chiConfigd.configmap.name" -}}
{{- if .Values.existingChiConfigdConfigmap -}}
    {{- print (tpl .Values.existingChiConfigdConfigmap $) -}}
{{- else -}}
    {{- printf "%s-chi-configd" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the ClickHouse Installation usersd configmap
*/}}
{{- define "clickhouse-operator.chiUsersd.configmap.name" -}}
{{- if .Values.existingChiUsersdConfigmap -}}
    {{- print (tpl .Values.existingChiUsersdConfigmap $) -}}
{{- else -}}
    {{- printf "%s-chi-usersd" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the ClickHouse Keeper Installation templates configmap
*/}}
{{- define "clickhouse-operator.chkTemplates.configmap.name" -}}
{{- if .Values.existingChkTemplatesConfigmap -}}
    {{- print (tpl .Values.existingChkTemplatesConfigmap $) -}}
{{- else -}}
    {{- printf "%s-chk-templates" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the ClickHouse Keeper Installation configd configmap
*/}}
{{- define "clickhouse-operator.chkConfigd.configmap.name" -}}
{{- if .Values.existingChkConfigdConfigmap -}}
    {{- print (tpl .Values.existingChkConfigdConfigmap $) -}}
{{- else -}}
    {{- printf "%s-chk-configd" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the ClickHouse Keeper Installation usersd configmap
*/}}
{{- define "clickhouse-operator.chkUsersd.configmap.name" -}}
{{- if .Values.existingChkUsersdConfigmap -}}
    {{- print (tpl .Values.existingChkUsersdConfigmap $) -}}
{{- else -}}
    {{- printf "%s-chk-usersd" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the ClickHouse credentials secret
*/}}
{{- define "clickhouse-operator.secret.name" -}}
{{- if .Values.auth.existingSecret -}}
    {{- print (tpl .Values.auth.existingSecret .) -}}
{{- else -}}
    {{- print (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret key that contains the ClickHouse admin username
*/}}
{{- define "clickhouse-operator.secret.usernameKey" -}}
{{- if and .Values.auth.existingSecret .Values.auth.existingSecretUsernameKey -}}
    {{- print (tpl .Values.auth.existingSecretUsernameKey .) -}}
{{- else -}}
    {{- print "username" -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret key that contains the ClickHouse admin password
*/}}
{{- define "clickhouse-operator.secret.passwordKey" -}}
{{- if and .Values.auth.existingSecret .Values.auth.existingSecretPasswordKey -}}
    {{- print (tpl .Values.auth.existingSecretPasswordKey .) -}}
{{- else -}}
    {{- print "password" -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "clickhouse-operator.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "clickhouse-operator.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of ClickHouse Operator - Incorrect extra volume settings
*/}}
{{- define "clickhouse-operator.validateValues.extraVolumes" -}}
{{- if and .Values.extraVolumes (not .Values.extraVolumeMounts) -}}
clickhouse-operator: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them. Please set
    the extraVolumeMounts value
{{- end -}}
{{- end -}}
