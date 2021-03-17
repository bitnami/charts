{{/*
Return the proper wavefront-prometheus-storage-adapter image name
*/}}
{{- define "wavefront-prometheus-storage-adapter.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wavefront-prometheus-storage-adapter.proxy.fullname" -}}
{{- printf "%s-%s" .Release.Name "wavefront-proxy" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "wavefront-prometheus-storage-adapter.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "wavefront-prometheus-storage-adapter.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "wavefront-prometheus-storage-adapter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s-foo" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "wavefront-prometheus-storage-adapter.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "wavefront-prometheus-storage-adapter.validateValues.foo" .) -}}
{{- $messages := append $messages (include "wavefront-prometheus-storage-adapter.validateValues.bar" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}
