{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper ASP.NET Core image name
*/}}
{{- define "aspnet-core.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper GIT image name
*/}}
{{- define "aspnet-core.git.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.appFromExternalRepo.clone.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper .NET SDK image name
*/}}
{{- define "aspnet-core.sdk.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.appFromExternalRepo.publish.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "aspnet-core.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.appFromExternalRepo.clone.image .Values.appFromExternalRepo.publish.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the Service Account to use
*/}}
{{- define "aspnet-core.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
    {{- default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else }}
    {{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "aspnet-core.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "aspnet-core.validateValues.customApp" .) -}}
{{- $messages := append $messages (include "aspnet-core.validateValues.appFromExistingPVC" .) -}}
{{- $messages := append $messages (include "aspnet-core.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of ASP.NET Core - Methods to mount custom app */}}
{{- define "aspnet-core.validateValues.customApp" -}}
{{- if and .Values.appFromExternalRepo.enabled .Values.appFromExistingPVC.enabled -}}
aspnet-core: custom app
    You cannot download your custom ASP.NET Core app from a GitHub repo
    and mount it from an existing PVC at the same time. Please use one
    method or the other:

        appFromExternalRepo.enabled=true
        appFromExistingPVC.enabled=false

    or:

        appFromExternalRepo.enabled=false
        appFromExistingPVC.enabled=true
{{- end -}}
{{- end -}}

{{/* Validate values of ASP.NET Core - Mounte app from existing PVC */}}
{{- define "aspnet-core.validateValues.appFromExistingPVC" -}}
{{- if and .Values.appFromExistingPVC.enabled (empty .Values.appFromExistingPVC.existingClaim) -}}
aspnet-core: appFromExistingPVC
    You enabled mounting your custom ASP.NET Core app from an existing PVC,
    but you didn't set the appFromExistingPVC.existingClaim parameter.
{{- end -}}
{{- end -}}

{{/* Validate values of ASP.NET Core - Incorrect extra volume settings */}}
{{- define "aspnet-core.validateValues.extraVolumes" -}}
{{- if and .Values.extraVolumes (not (or .Values.extraVolumeMounts .Values.appFromExternalRepo.clone.extraVolumeMounts)) -}}
aspnet-core: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them.
    Please also set the extraVolumeMounts parameter.
{{- end -}}
{{- end -}}
