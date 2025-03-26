{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "minio-operator.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.minioImage) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper minio-operator Operator image name
*/}}
{{- define "minio-operator.operator.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper MinIO(R) image name
*/}}
{{- define "minio-operator.minio.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.minioImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper MinIO(R) Operator Sidecar image name
*/}}
{{- define "minio-operator.sidecar.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.sidecarImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper KES(r) image name
*/}}
{{- define "minio-operator.kes.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.kesImage "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use (minio-operator Operator)
*/}}
{{- define "minio-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Validate values for minio-operator.
*/}}
{{- define "minio-operator.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "minio-operator.validateValues.extraVolumes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Apache - Incorrect extra volume settings
*/}}
{{- define "minio-operator.validateValues.extraVolumes" -}}
{{- if and .Values.extraVolumes (not .Values.extraVolumeMounts) -}}
minio-operator: missing-extra-volume-mounts
    You specified extra volumes but not mount points for them. Please set
    the extraVolumeMounts value
{{- end -}}
{{- end -}}

