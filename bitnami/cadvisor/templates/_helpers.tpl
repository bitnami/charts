{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper cAdvisor image name
*/}}
{{- define "cadvisor.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "cadvisor.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "cadvisor.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{- default (include "common.names.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Validate values for cAdvisor
*/}}
{{- define "cadvisor.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "cadvisor.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of cAdvisor - Incorrect extra volume settings
*/}}
{{- define "cadvisor.validateValues.extraVolumes" -}}
{{- if and .Values.extraVolumes (not .Values.extraVolumeMounts) -}}
cadvisor: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them. Please set
    the extraVolumeMounts value
{{- end -}}
{{- end -}}

