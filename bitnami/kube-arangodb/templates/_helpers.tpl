{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kube-arangodb.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.arangodbImage ) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper kube-arangodb Operator image name
*/}}
{{- define "kube-arangodb.operator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper PostgreSQL image name
*/}}
{{- define "kube-arangodb.arangodb.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.arangodbImage "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (kube-arangodb Operator)
*/}}
{{- define "kube-arangodb.serviceAccountName" -}}
{{- if .Values.serviceAccount.operator.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.operator.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.operator.name }}
{{- end -}}
{{- end -}}

{{/*
Get the admin credentials secret.
*/}}
{{- define "kube-arangodb.secretName" -}}
{{- if .Values.auth.existingSecret -}}
    {{- tpl .Values.auth.existingSecret $ -}}
{{- else }}
    {{- include "common.names.fullname" .  -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use (kube-arangodb Operator)
*/}}
{{- define "kube-arangodb.job.serviceAccountName" -}}
{{- if .Values.serviceAccount.job.create -}}
    {{ default (printf "%s-job" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-") .Values.serviceAccount.job.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.job.name }}
{{- end -}}
{{- end -}}

{{/*
Validate values for kube-arangodb.
*/}}
{{- define "kube-arangodb.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "kube-arangodb.validateValues.scope" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/* Validate values of kube-arangodb - Scope is correct */}}
{{- define "kube-arangodb.validateValues.scope" -}}
{{- $allowedValues := list "legacy" "namespaced" -}}
{{- if not (has .Values.scope $allowedValues) -}}
kube-arangodb: scope
    Allowed values for `scope` are {{ join "," $allowedValues }}.
{{- end -}}
{{- end -}}
