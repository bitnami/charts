{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "aspnet-core.name" -}}
{{- include "common.names.name" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aspnet-core.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aspnet-core.chart" -}}
{{- include "common.names.chart" . -}}
{{- end }}

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
    {{- default (include "aspnet-core.fullname" .) .Values.serviceAccount.name }}
{{- else }}
    {{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "aspnet-core.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "aspnet-core.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of ASP.NET Core - Incorrect extra volume settings */}}
{{- define "aspnet-core.validateValues.extraVolumes" -}}
{{- if and .Values.extraVolumes (not .Values.extraVolumeMounts) -}}
aspnet-core: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them.
    Please also set the extraVolumeMounts parameter.
{{- end -}}
{{- end -}}
