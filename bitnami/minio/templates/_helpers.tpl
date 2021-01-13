{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper MinIO(TM) image name
*/}}
{{- define "minio.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}

{{- end -}}

{{/*
Return the proper MinIO(TM) Client image name
*/}}
{{- define "minio.clientImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.clientImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "minio.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "minio.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.clientImage .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return MinIO(TM) accessKey
*/}}
{{- define "minio.accessKey" -}}
{{- $accessKey := coalesce .Values.global.minio.accessKey .Values.accessKey.password -}}
{{- if $accessKey }}
    {{- $accessKey -}}
{{- else if (not .Values.accessKey.forcePassword) }}
    {{- randAlphaNum 10 -}}
{{- else -}}
    {{ required "An Access Key is required!" .Values.accessKey.password }}
{{- end -}}
{{- end -}}

{{/*
Return MinIO(TM) secretKey
*/}}
{{- define "minio.secretKey" -}}
{{- $secretKey := coalesce .Values.global.minio.secretKey .Values.secretKey.password -}}
{{- if $secretKey }}
    {{- $secretKey -}}
{{- else if (not .Values.secretKey.forcePassword) }}
    {{- randAlphaNum 40 -}}
{{- else -}}
    {{ required "A Secret Key is required!" .Values.secretKey.password }}
{{- end -}}
{{- end -}}

{{/*
Get the credentials secret.
*/}}
{{- define "minio.secretName" -}}
{{- if .Values.global.minio.existingSecret }}
    {{- printf "%s" .Values.global.minio.existingSecret -}}
{{- else if .Values.existingSecret -}}
    {{- printf "%s" .Values.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created
*/}}
{{- define "minio.createSecret" -}}
{{- if .Values.global.minio.existingSecret }}
{{- else if .Values.existingSecret -}}
{{- else -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns the proper service account name depending if an explicit service account name is set
in the values file. If the name is not set it will default to either common.names.fullname if serviceAccount.create
is true or default otherwise.
*/}}
{{- define "minio.serviceAccountName" -}}
    {{- if .Values.serviceAccount.create -}}
        {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
    {{- else -}}
        {{ default "default" .Values.serviceAccount.name }}
    {{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "minio.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "minio.validateValues.mode" .) -}}
{{- $messages := append $messages (include "minio.validateValues.replicaCount" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of MinIO(TM) - must provide a valid mode ("distributed" or "standalone") */}}
{{- define "minio.validateValues.mode" -}}
{{- if and (ne .Values.mode "distributed") (ne .Values.mode "standalone") -}}
minio: mode
    Invalid mode selected. Valid values are "distributed" and
    "standalone". Please set a valid mode (--set mode="xxxx")
{{- end -}}
{{- end -}}

{{/* Validate values of MinIO(TM) - number of replicas must be even, greater than 4 and lower than 32 */}}
{{- define "minio.validateValues.replicaCount" -}}
{{- $replicaCount := int .Values.statefulset.replicaCount }}
{{- if and (eq .Values.mode "distributed") (or (eq (mod $replicaCount 2) 1) (lt $replicaCount 4) (gt $replicaCount 32)) -}}
minio: replicaCount
    Number of replicas must be even, greater than 4 and lower than 32!!
    Please set a valid number of replicas (--set statefulset.replicaCount=X)
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "minio.checkRollingTags" -}}
{{- include "common.warnings.rollingTag" .Values.image }}
{{- include "common.warnings.rollingTag" .Values.clientImage }}
{{- end -}}
