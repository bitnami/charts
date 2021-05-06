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
Compile all warnings into a single message, and call fail.
*/}}
{{- define "pytorch.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "pytorch.validateValues.mode" .) -}}
{{- $messages := append $messages (include "pytorch.validateValues.worldSize" .) -}}
{{- $messages := append $messages (include "pytorch.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of PyTorch - must provide a valid mode ("distributed" or "standalone") */}}
{{- define "pytorch.validateValues.mode" -}}
{{- if and (ne .Values.mode "distributed") (ne .Values.mode "standalone") -}}
pytorch: mode
    Invalid mode selected. Valid values are "distributed" and
    "standalone". Please set a valid mode (--set mode="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of PyTorch - number of replicas must be even, greater than 4 and lower than 32 */}}
{{- define "pytorch.validateValues.worldSize" -}}
{{- $replicaCount := int .Values.worldSize }}
{{- if and (eq .Values.mode "distributed") (or (lt $replicaCount 1) (gt $replicaCount 32)) -}}
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
{{- end -}}
