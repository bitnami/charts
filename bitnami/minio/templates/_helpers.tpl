{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper MinIO(R) image name
*/}}
{{- define "minio.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}

{{- end -}}

{{/*
Return the proper MinIO(R) Client image name
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
Return MinIO(R) accessKey
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
Return MinIO(R) secretKey
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
Return true if a PVC object should be created (only in standalone mode)
*/}}
{{- define "minio.createPVC" -}}
{{- if and .Values.persistence.enabled (not .Values.persistence.existingClaim) (eq .Values.mode "standalone") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the PVC name (only in standalone mode)
*/}}
{{- define "minio.claimName" -}}
{{- if and .Values.persistence.existingClaim }}
    {{- printf "%s" (tpl .Values.persistence.existingClaim $) -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
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
{{- $messages := append $messages (include "minio.validateValues.totalDrives" .) -}}
{{- $messages := append $messages (include "minio.validateValues.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of MinIO(R) - must provide a valid mode ("distributed" or "standalone") */}}
{{- define "minio.validateValues.mode" -}}
{{- if and (ne .Values.mode "distributed") (ne .Values.mode "standalone") -}}
minio: mode
    Invalid mode selected. Valid values are "distributed" and
    "standalone". Please set a valid mode (--set mode="xxxx")
{{- end -}}
{{- end -}}

{{/*
Validate values of MinIO(R) - total number of drives should be multiple of 4
*/}}
{{- define "minio.validateValues.totalDrives" -}}
{{- $replicaCount := int .Values.statefulset.replicaCount }}
{{- $drivesPerNode := int .Values.statefulset.drivesPerNode }}
{{- $totalDrives := mul $replicaCount $drivesPerNode }}
{{- if and (eq .Values.mode "distributed") (or (not (eq (mod $totalDrives 4) 0)) (lt $totalDrives 4)) -}}
minio: total drives
    The total number of drives should be multiple of 4 to guarantee erasure coding!
    Please set a combination of nodes, and drives per node that match this condition.
    For instance (--set statefulset.replicaCount=2 --set statefulset.drivesPerNode=2)
{{- end -}}
{{- end -}}

{{/*
Validate values of MinIO(R) - TLS secret must provided if TLS is enabled
*/}}
{{- define "minio.validateValues.tls" -}}
{{- if and .Values.tls.enabled (not .Values.tls.secretName) }}
minio: tls.secretName
    The name of an existin secret containing the certificates must be provided
    if TLS is enabled. Please set its name (--set tls.secretName=X)
{{- end -}}
{{- end -}}
