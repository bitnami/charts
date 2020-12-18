{{/*
Return the proper %%MAIN_OBJECT_BLOCK%% image name
*/}}
{{- define "%%TEMPLATE_NAME%%.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.%%MAIN_OBJECT_BLOCK%%.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "%%TEMPLATE_NAME%%.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "%%TEMPLATE_NAME%%.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.%%MAIN_OBJECT_BLOCK%%.image .Values.%%SECONDARY_OBJECT_BLOCK%%.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "%%TEMPLATE_NAME%%.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s-foo" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "%%TEMPLATE_NAME%%.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "%%TEMPLATE_NAME%%.validateValues.foo" .) -}}
{{- $messages := append $messages (include "%%TEMPLATE_NAME%%.validateValues.bar" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

