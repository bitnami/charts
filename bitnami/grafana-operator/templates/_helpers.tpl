{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper image name
*/}}
{{- define "grafana-operator.getBaseImage" -}}
{{- $registryName := .image.registry -}}
{{- $repositoryName := .image.repository -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .context.Values.global }}
    {{- if .context.Values.global.imageRegistry }}
        {{- printf "%s/%s" .context.Values.global.imageRegistry $repositoryName -}}
    {{- else -}}
        {{- printf "%s/%s" $registryName $repositoryName -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s" $registryName $repositoryName -}}
{{- end -}}
{{- end -}}


{{/*
Create the name of the grafana-operator service account to use
*/}}
{{- define "grafana-operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create -}}
    {{ default (printf "%s" (include "common.names.fullname" .)) .Values.operator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.operator.serviceAccount.name }}
{{- end -}}
{{- end -}}
