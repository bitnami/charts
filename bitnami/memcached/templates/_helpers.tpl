{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Memcached image name
*/}}
{{- define "memcached.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "memcached.metrics.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) }}
{{- end -}}


{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "memcached.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "memcached.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "memcached.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "memcached.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- include "common.warnings.rollingTag" .Values.volumePermissions.image }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "memcached.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "memcached.validateValues.architecture" .) -}}
{{- $messages := append $messages (include "memcached.validateValues.replicaCount" .) -}}
{{- $messages := append $messages (include "memcached.validateValues.auth" .) -}}
{{- $messages := append $messages (include "memcached.validateValues.readOnlyRootFilesystem" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Memcached - must provide a valid architecture */}}
{{- define "memcached.validateValues.architecture" -}}
{{- if and (ne .Values.architecture "standalone") (ne .Values.architecture "high-availability") -}}
memcached: architecture
    Invalid architecture selected. Valid values are "standalone" and
    "high-availability". Please set a valid architecture (--set architecture="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of Memcached - number of replicas */}}
{{- define "memcached.validateValues.replicaCount" -}}
{{- $replicaCount := int .Values.replicaCount }}
{{- if and (eq .Values.architecture "standalone") (gt $replicaCount 1) -}}
memcached: replicaCount
    The standalone architecture doesn't allow to run more than 1 replica.
    Please set a valid number of replicas (--set memcached.replicaCount=1) or
    use the "high-availability" architecture (--set architecture="high-availability")
{{- end -}}
{{- end -}}

{{/* Validate values of Memcached - authentication */}}
{{- define "memcached.validateValues.auth" -}}
{{- if and .Values.auth.enabled (empty .Values.auth.username) -}}
memcached: auth.username
    Enabling authentication requires setting a valid admin username.
    Please set a valid username (--set auth.username="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of Memcached - containerSecurityContext.readOnlyRootFilesystem */}}
{{- define "memcached.validateValues.readOnlyRootFilesystem" -}}
{{- if and .Values.containerSecurityContext.enabled .Values.containerSecurityContext.readOnlyRootFilesystem .Values.auth.enabled -}}
memcached: containerSecurityContext.readOnlyRootFilesystem
    Enabling authentication is not compatible with using a read-only filesystem.
    Please disable it (--set containerSecurityContext.readOnlyRootFilesystem=false)
{{- end -}}
{{- end -}}
