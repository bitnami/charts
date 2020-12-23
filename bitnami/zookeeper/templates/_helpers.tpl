{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Zookeeper image name
*/}}
{{- define "zookeeper.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "zookeeper.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "zookeeper.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Check if there are rolling tags in the images
*/}}
{{- define "zookeeper.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "zookeeper.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return ZooKeeper Client Password
*/}}
{{- define "zookeeper.clientPassword" -}}
{{- if .Values.auth.clientPassword -}}
    {{- .Values.auth.clientPassword -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{/*
Return ZooKeeper Servers Passwords
*/}}
{{- define "zookeeper.serverPasswords" -}}
{{- if .Values.auth.serverPasswords -}}
    {{- .Values.auth.serverPasswords -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{/*
Return ZooKeeper Namespace to use
*/}}
{{- define "zookeeper.namespace" -}}
    {{- if .Values.namespaceOverride }}
        {{- .Values.namespaceOverride -}}
    {{- else }}
        {{- .Release.Namespace -}}
    {{- end }}
{{- end -}}