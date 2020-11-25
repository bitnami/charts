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
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "memcached.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "memcached.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.metrics.image }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "memcached.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "memcached.validateValues.architecture" .) -}}
{{- $messages := append $messages (include "memcached.validateValues.replicaCount" .) -}}
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

{{/* Validate values of Memcached - securityContext.readOnlyRootFilesystem */}}
{{- define "memcached.validateValues.readOnlyRootFilesystem" -}}
{{- if and .Values.securityContext.enabled .Values.securityContext.readOnlyRootFilesystem (not (empty .Values.memcachedPassword)) -}}
memcached: securityContext.readOnlyRootFilesystem
    Enabling authentication is not compatible with using a read-only filesystem.
    Please disable it (--set securityContext.readOnlyRootFilesystem=false)
{{- end -}}
{{- end -}}
