{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper PyTorch image name
*/}}
{{- define "pytorch.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper git image name
*/}}
{{- define "git.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.git "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "pytorch.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "pytorch.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.git .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper name for master related resources
*/}}
{{- define "pytorch.master.name" -}}
{{- $architecture := coalesce .Values.mode .Values.architecture }}
{{- if eq .Values.architecture "distributed" }}
{{- printf "%s-master" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- include "common.names.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Return the proper securityContext when enabled by the deprecated or new params
*/}}
{{- define "pytorch.securityContext" -}}
{{- if .Values.securityContext }}
{{- if .Values.securityContext.enabled }}
      securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.securityContext "context" $) | nindent 8 }}
{{- end }}
{{- else }}
{{- if .Values.podSecurityContext.enabled }}
      securityContext: {{- include "common.compatibility.renderSecurityContext" (dict "secContext" .Values.podSecurityContext "context" $) | nindent 8 }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "pytorch.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "pytorch.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "pytorch.validateValues.architecture" .) -}}
{{- $messages := append $messages (include "pytorch.validateValues.worldSize" .) -}}
{{- $messages := append $messages (include "pytorch.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of PyTorch - must provide a valid architecture ("distributed" or "standalone") */}}
{{- define "pytorch.validateValues.architecture" -}}
{{- if .Values.mode -}}
{{- if and (ne .Values.mode "distributed") (ne .Values.mode "standalone") -}}
pytorch: mode
    Invalid mode selected. Valid values are "distributed" and
    "standalone". Please set a valid mode (--set mode="xxxx")
{{- end -}}
{{- else -}}
{{- if and (ne .Values.architecture "distributed") (ne .Values.architecture "standalone") -}}
pytorch: architecture
    Invalid architecture selected. Valid values are "distributed" and
    "standalone". Please set a valid architecture (--set architecture="xxxx")
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate values of PyTorch - number of replicas must be even, greater than 4 and lower than 32 */}}
{{- define "pytorch.validateValues.worldSize" -}}
{{- $replicaCount := int .Values.worldSize }}
{{- $architecture := coalesce .Values.mode .Values.architecture }}
{{- if and (eq $architecture "distributed") (or (lt $replicaCount 1) (gt $replicaCount 32)) -}}
pytorch: worldSize
    World size must be greater than 1 and lower than 32 in distributed mode!!
    Please set a valid world size (--set worldSize=X)
{{- end -}}
{{- end -}}

{{/* Validate values of PyTorch - Incorrect extra volume settings */}}
{{- define "pytorch.validateValues.extraVolumes" -}}
{{- if and (.Values.extraVolumes) (not (or .Values.extraVolumeMounts .Values.cloneFilesFromGit.extraVolumeMounts)) -}}
pytorch: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them. Please set
    the extraVolumeMounts value
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "pytorch.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.git }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end -}}
